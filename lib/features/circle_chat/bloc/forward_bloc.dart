import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/utils/list_filter_utils.dart';
import 'package:senior_circle/features/circle_chat/models/forward_item_model.dart';
import 'package:senior_circle/features/circle_chat/models/circle_chat_message_model.dart';
import 'package:senior_circle/features/circle_chat/repositories/circle_chat_messages_repository.dart';
import 'package:senior_circle/features/my_circle_home/models/my_circle_model.dart';
import 'package:senior_circle/features/my_circle_home/repository/my_circle_repository.dart';
import 'package:senior_circle/features/view_friends/models/friends_model.dart';
import 'package:senior_circle/features/view_friends/repository/view_friends_repository.dart';
import 'forward_event.dart';
import 'forward_state.dart';

class ForwardBloc extends Bloc<ForwardEvent, ForwardState> {
  final CircleChatMessagesRepository _chatRepository;
  final ViewFriendsRepository _friendsRepository;
  final MyCircleRepository _circlesRepository;

  ForwardBloc({
    required CircleChatMessagesRepository chatRepository,
    ViewFriendsRepository? friendsRepository,
    MyCircleRepository? circlesRepository,
  })  : _chatRepository = chatRepository,
        _friendsRepository = friendsRepository ?? ViewFriendsRepository(),
        _circlesRepository = circlesRepository ?? MyCircleRepository(),
        super(ForwardInitial()) {
    on<LoadForwardTargets>(_onLoadForwardTargets);
    on<FilterTargets>(_onFilterTargets);
    on<ToggleSelection>(_onToggleSelection);
    on<SubmitForward>(_onSubmitForward);
  }

  Future<void> _onLoadForwardTargets(
    LoadForwardTargets event,
    Emitter<ForwardState> emit,
  ) async {
    emit(ForwardLoading());

    try {
      final userId = _friendsRepository.currentUserId;
      if (userId == null) throw Exception('User not logged in');

      final results = await Future.wait([
        _friendsRepository.getFriends(userId),
        _circlesRepository.fetchMyCircleChats(),
      ]);

      final friends = results[0] as List<Friend>;
      final chats = results[1] as List<MyCircle>;
      
      debugPrint('🟦 [ForwardBloc] Loaded ${friends.length} friends and ${chats.length} chats');

      final List<ForwardItem> items = [];

      for (final chat in chats.where((c) => c.isGroup)) {
        items.add(ForwardItem(
          id: chat.id,
          name: chat.name,
          avatarUrl: chat.imageUrl,
          isGroup: true,
        ));
      }

      for (final friend in friends) {
        final conversation = chats.firstWhere(
          (c) => !c.isGroup && c.otherUserId == friend.id,
          orElse: () => MyCircle(
            id: '',
            name: friend.name,
            imageUrl: friend.profileImage,
            updatedAt: null,
            otherUserId: friend.id,
            createdAt: null,
          ),
        );
        
        if (conversation.id.isNotEmpty) {
           debugPrint('🟦 [ForwardBloc] Found existing chat for friend ${friend.name} (${friend.id}) -> ${conversation.id}');
        } else {
           debugPrint('🟦 [ForwardBloc] No existing chat for friend ${friend.name} (${friend.id})');
        }

        items.add(ForwardItem(
          id: conversation.id,
          name: friend.name,
          avatarUrl: friend.profileImage,
          isGroup: false,
          otherUserId: friend.id,
        ));
      }

      emit(ForwardLoaded(
        allItems: items,
        filteredItems: items,
        selectedItems: const {},
      ));
    } catch (e) {
      emit(ForwardError('Failed to load forwarding targets: $e'));
    }
  }

  void _onFilterTargets(
    FilterTargets event,
    Emitter<ForwardState> emit,
  ) {
    if (state is ForwardLoaded) {
      final currentState = state as ForwardLoaded;

      final filtered = filterByName(
        items: currentState.allItems,
        query: event.query,
        nameExtractor: (item) => item.name,
      );

      emit(currentState.copyWith(filteredItems: filtered));
    }
  }

  void _onToggleSelection(
    ToggleSelection event,
    Emitter<ForwardState> emit,
  ) {
    if (state is ForwardLoaded) {
      final currentState = state as ForwardLoaded;
      final newSelection = Set<ForwardItem>.from(currentState.selectedItems);

      if (newSelection.contains(event.item)) {
        newSelection.remove(event.item);
      } else {
        newSelection.add(event.item);
      }

      emit(currentState.copyWith(selectedItems: newSelection));
    }
  }

  Future<void> _onSubmitForward(
    SubmitForward event,
    Emitter<ForwardState> emit,
  ) async {
    if (state is! ForwardLoaded) return;

    final currentState = state as ForwardLoaded;
    final selectedItems = currentState.selectedItems;
    
    debugPrint('🟦 [ForwardBloc] Submitting forward to ${selectedItems.length} targets');

    if (selectedItems.isEmpty) return;

    // Single Target
    if (selectedItems.length == 1) {
      final item = selectedItems.first;
      if (item.isGroup) {
        await _handleSingleGroupForward(item, event.message, emit);
      } else {
        await _handleSingleIndividualForward(item, event.message, emit);
      }
      return;
    }

    // Multiple Targets
    try {
      final individualTargets = selectedItems
          .where((i) => !i.isGroup)
          .map((i) => {
                'conversationId': i.id,
                'otherUserId': i.otherUserId,
              })
          .toList();

      final circleIds = selectedItems
          .where((i) => i.isGroup)
          .map((i) => i.id)
          .toList();

      final payload = _buildForwardPayload(event.message);

      for (final target in individualTargets) {
          final String? existingConvId = target['conversationId'];
          final String? otherUserId = target['otherUserId'];
          
          String targetConvId;
          if (existingConvId != null && existingConvId.isNotEmpty) {
            targetConvId = existingConvId;
          } else if (otherUserId != null) {
            targetConvId = await _chatRepository.getOrCreateConversation(otherUserId);
          } else {
            continue;
          }

          await _chatRepository.forwardMessage(
            conversationId: targetConvId,
            payload: payload,
          );
      }

      for (final circleId in circleIds) {
          await _chatRepository.forwardMessage(
            circleId: circleId,
            payload: payload,
          );
      }

      emit(const ForwardSuccess('Message forwarded successfully'));

    } catch (e) {
      emit(ForwardError('Failed to forward messages: $e'));
    }
  }

  Future<void> _handleSingleGroupForward(
    ForwardItem item, 
    CircleChatMessage message, 
    Emitter<ForwardState> emit
  ) async {
    try {
      final chats = await _circlesRepository.fetchMyCircleChats();
      final circleChat = chats.firstWhere((c) => c.id == item.id);
      
      final currentUserId = _chatRepository.currentUserId;
      final isAdmin = circleChat.adminId == currentUserId;

      emit(ForwardNavigateToGroup(
        chat: circleChat,
        message: message,
        isAdmin: isAdmin,
      ));
    } catch (e) {
      emit(ForwardError('Could not find circle info: $e'));
    }
  }

  Future<void> _handleSingleIndividualForward(
    ForwardItem item,
    CircleChatMessage message,
    Emitter<ForwardState> emit,
  ) async {
    debugPrint('🟦 [ForwardBloc] Handling single individual forward to ${item.name} (id: ${item.id}, other: ${item.otherUserId})');
    try {
      String conversationId = item.id;

      if (conversationId.isEmpty && item.otherUserId != null) {
        debugPrint('🟦 [ForwardBloc] Creating conversation for user ${item.otherUserId}');
        conversationId = await _chatRepository.getOrCreateConversation(item.otherUserId!);
        debugPrint('🟩 [ForwardBloc] Conversation created/retrieved: $conversationId');
      }
      
      if (conversationId.isEmpty) {
        throw Exception('Could not determine conversation ID');
      }

      final individualChat = MyCircle(
        id: conversationId,
        name: item.name,
        imageUrl: item.avatarUrl,
        updatedAt: DateTime.now(),
        otherUserId: item.otherUserId,
        createdAt: null,
      );

      emit(ForwardNavigateToIndividual(
        chat: individualChat,
        message: message,
      ));
    } catch (e) {
       debugPrint('🟥 [ForwardBloc] Error in single individual forward: $e');
      emit(ForwardError('Failed to prepare individual chat: $e'));
    }
  }

  Map<String, dynamic> _buildForwardPayload(CircleChatMessage message) {
    return {
      'content': message.text,         
      'media_url': message.imagePath,
      'media_type': message.mediaType,
    };
  }
}
