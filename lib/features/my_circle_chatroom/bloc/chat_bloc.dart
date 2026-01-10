import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/enum/chat_message_type.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_extensions.dart';
import 'package:senior_circle/core/utils/reaction_utils.dart';
import 'package:senior_circle/features/my_circle_chatroom/repositories/group_chat_reppository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GroupChatRepository repository;
  String? _circleId;
  RealtimeChannel? _groupChannel;

  ChatBloc({required this.repository})
    : super(const ChatState(groupMessages: [])) {
    on<LoadGroupMessages>(_onLoadGroupMessages);
    on<GroupMessageInserted>(_onGroupMessageInserted);
    on<SendGroupMessage>(_onSendGroupMessage);
    on<DeleteGroupMessage>(_onDeleteGroupMessage);
    on<GroupReactionChanged>(_onGroupReactionChanged);
    on<ToggleReaction>(_onToggleReaction);
    on<ToggleGroupThread>(_onToggleGroupThread);
    on<ToggleReplyInput>(_onToggleReplyInput);
    on<ToggleStar>(_onToggleStar);
    on<ForwardMessage>(_onForwardMessage);

  }

  Future<void> _onLoadGroupMessages(
    LoadGroupMessages event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    _circleId = event.chatId;

    try {
      final messages = await repository.fetchGroupMessages(
        circleId: event.chatId,
      );

      emit(state.copyWith(groupMessages: messages, isLoading: false));

      _subscribeToGroupRealtime(event.chatId);
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load messages'));
    }
  }

  Future<void> _onSendGroupMessage(
    SendGroupMessage event,
    Emitter<ChatState> emit,
  ) async {
    final currentUser = Supabase.instance.client.auth.currentUser;

    if (currentUser == null) {
      debugPrint('🟥 [ChatBloc] User not logged in');
      return;
    }

    final circleId = event.circleId ?? _circleId;
    if (circleId == null) {
      debugPrint('🟥 [ChatBloc] circleId is NULL');
      return;
    }

    debugPrint('🟦 [ChatBloc] SendGroupMessage triggered');
    debugPrint('🟦 text: ${event.text}');
    debugPrint('🟦 imagePath: ${event.imagePath}');
    debugPrint('🟦 replyTo: ${event.replyToMessageId}');
    debugPrint('🟦 circleId: $circleId');

    try {
      emit(state.copyWith(isSending: true));
      String? imageUrl;

      if (event.imagePath != null) {
        if (event.imagePath!.startsWith('http')) {
          debugPrint('🟨 [ChatBloc] imagePath is a URL, skipping upload');
          imageUrl = event.imagePath;
        } else {
          debugPrint('🟨 [ChatBloc] Uploading image...');
          imageUrl = await repository.uploadCircleImage(File(event.imagePath!));
          debugPrint('🟩 [ChatBloc] Image uploaded: $imageUrl');
        }
      }

      debugPrint('🟨 [ChatBloc] Sending message to database');

      final newMessage = await repository.sendGroupMessage(
        circleId: circleId,
        content: event.text ?? '',
        mediaUrl: imageUrl,
        mediaType: imageUrl != null ? 'image' : 'text',
        replyToMessageId: event.replyToMessageId,
      );

      debugPrint('🟩 [ChatBloc] Message sent successfully');
      emit(state.copyWith(
        isSending: false,
        prefilledInputText: null, // Clear after successful send
        prefilledMedia: null,      // Clear after successful send
      ));
      add(GroupMessageInserted(newMessage));
      
    } catch (e, st) {
      debugPrint('🟥 [ChatBloc] Error sending message: $e');
      debugPrintStack(stackTrace: st);
      emit(state.copyWith(isSending: false, error: 'Failed to send message'));
    }
  }

  Future<void> _onDeleteGroupMessage(
    DeleteGroupMessage event,
    Emitter<ChatState> emit,
  ) async {
    final previousState = state;

    final updatedMessages = state.groupMessages
        .map((m) => m.removeRecursive(event.messageId))
        .whereType<GroupMessage>()
        .toList();

    emit(state.copyWith(groupMessages: updatedMessages));

    try {
      if (event.forEveryone) {
        await repository.deleteGroupMessage(event.messageId);
      } else {
        await repository.deleteGroupMessageForMe(event.messageId);
      }
    } catch (e) {
      debugPrint('[ChatBloc] Delete failed: $e');
      emit(previousState);
    }
  }

  void _onToggleReaction(ToggleReaction event, Emitter<ChatState> emit) {
    if (event.type == ChatMessageType.individual) return;

    final updatedMessages = _updateMessageInList(
      state.groupMessages,
      event.messageId,
      (msg) => msg.updateReaction(
        messageId: event.messageId,
        emoji: event.emoji,
        userId: event.userId,
        applyReactionFn: applyReaction,
      ),
    );

    emit(state.copyWith(groupMessages: updatedMessages));

    repository.toggleGroupReaction(
      messageId: event.messageId,
      emoji: event.emoji,
      userId: event.userId,
    );
  }

  void _onToggleGroupThread(ToggleGroupThread event, Emitter<ChatState> emit) {
    final updatedGroupMessages = _updateMessageInList(
      state.groupMessages,
      event.messageId,
      (message) {
        final willOpen = !message.isThreadOpen;
        return message.copyWith(
          isThreadOpen: willOpen,
          isReplyInputOpen: willOpen ? message.isReplyInputOpen : false,
        );
      },
      clearOthers: true,
    );

    emit(state.copyWith(groupMessages: updatedGroupMessages));
  }

  void _onToggleReplyInput(ToggleReplyInput event, Emitter<ChatState> emit) {
    final updatedGroupMessages = _updateMessageInList(
      state.groupMessages,
      event.messageId,
      (message) {
        final willOpen = !message.isReplyInputOpen;
        return message.copyWith(
          isReplyInputOpen: willOpen,
          isThreadOpen: willOpen ? message.isThreadOpen : false,
        );
      },
      clearOthers: true,
    );

    emit(state.copyWith(groupMessages: updatedGroupMessages));
  }

  Future<void> _onToggleStar(ToggleStar event, Emitter<ChatState> emit) async {
    final targetMessage = _findMessageInList(state.groupMessages, event.messageId);
    if (targetMessage == null) return;

    final updatedMessages = _updateMessageInList(
      state.groupMessages,
      event.messageId,
      (msg) => msg.toggleStar(event.messageId),
    );

    emit(state.copyWith(groupMessages: updatedMessages));
    try {
      await repository.toggleSaveMessage(message: targetMessage);
    } catch (e) {
      debugPrint('Failed to toggle star: $e');
    }
  }

  Future<void> _onForwardMessage(
    ForwardMessage event,
    Emitter<ChatState> emit,
  ) async {
    debugPrint('🟦 [Forward] ForwardMessage triggered');

    final message = event.message;
    final individualTargets = event.individualTargets;
    final circles = event.circleIds;

    debugPrint('🟦 [Forward] Individual count: ${individualTargets.length}, Circle count: ${circles.length}');

    final payload = _buildForwardPayload(message);

    // 1. Check for single recipient pre-fill (Individual or Circle)
    final totalTargets = individualTargets.length + circles.length;
    if (totalTargets == 1) {
      debugPrint('🟨 [Forward] Single target detected → setting prefill state');
      emit(state.copyWith(
        prefilledInputText: message.text,
        prefilledMedia: message.imagePath != null
            ? ForwardMedia(url: message.imagePath!, type: message.mediaType)
            : null,
      ));
      return;
    }

    // 2. Multi-forward logic (direct send)
    for (final target in individualTargets) {
      try {
        final String? existingConvId = target['conversationId'];
        final String? otherUserId = target['otherUserId'];
        
        String targetConvId;
        if (existingConvId != null && existingConvId.isNotEmpty) {
          targetConvId = existingConvId;
        } else if (otherUserId != null) {
          debugPrint('🟦 [Forward] Creating conversation for otherUserId $otherUserId');
          targetConvId = await repository.getOrCreateConversation(otherUserId);
        } else {
          continue;
        }

        debugPrint('🟦 [Forward] Sending to individual conversation $targetConvId');
        await repository.forwardMessage(
          conversationId: targetConvId,
          payload: payload,
        );
        debugPrint('🟩 [Forward] Sent to individual conversation $targetConvId');
      } catch (e) {
        debugPrint('🟥 [Forward] Failed for individual target $target: $e');
      }
    }

    for (final circleId in circles) {
      try {
        debugPrint('🟦 [Forward] Sending to circle $circleId');
        await repository.forwardMessage(
          circleId: circleId,
          payload: payload,
        );
        debugPrint('🟩 [Forward] Sent to circle $circleId');
      } catch (e) {
        debugPrint('🟥 [Forward] Failed for circle $circleId: $e');
      }
    }

    debugPrint('🟩 [Forward] Forward process completed');
  }

  Map<String, dynamic> _buildForwardPayload(GroupMessage message) {
    debugPrint('🟦 [Forward] Building forward payload');
    
    return {
      'content': message.text,         
      'media_url': message.imagePath,
      'media_type': message.mediaType,
    };
  }

  GroupMessage? _findMessageInList(List<GroupMessage> messages, String id) {
    for (final msg in messages) {
      final found = msg.findRecursive(id);
      if (found != null) return found;
    }
    return null;
  }

  List<GroupMessage> _updateMessageInList(
    List<GroupMessage> messages,
    String targetId,
    GroupMessage Function(GroupMessage) updateFn, {
    bool clearOthers = false,
  }) {
    return messages
        .map((m) => m.updateRecursive(targetId, updateFn, clearOthers: clearOthers))
        .toList();
  }

  void _onGroupMessageInserted(
    GroupMessageInserted event,
    Emitter<ChatState> emit,
  ) {
    if (event.message.replyToMessageId == null) {
      emit(state.copyWith(
          groupMessages: [event.message, ...state.groupMessages]));
      return;
    }

    final updatedMessages = state.groupMessages.map((msg) {
      return msg.addReply(event.message);
    }).toList();

    emit(state.copyWith(groupMessages: updatedMessages));
  }

  void _onGroupReactionChanged(
    GroupReactionChanged event,
    Emitter<ChatState> emit,
  ) {
    final updated = _updateMessageInList(
      state.groupMessages,
      event.messageId,
      (message) => message.updateReaction(
        messageId: event.messageId,
        emoji: event.emoji,
        userId: event.userId,
        applyReactionFn: applyReaction,
      ),
    );

    emit(state.copyWith(groupMessages: updated));
  }

  void _subscribeToGroupRealtime(String circleId) {
    if (_groupChannel != null && _circleId == circleId) {
      debugPrint('🟨 [ChatBloc] Realtime already subscribed');
      return;
    }

    _groupChannel?.unsubscribe();

    debugPrint('🟦 [ChatBloc] Subscribing to realtime for circle $circleId');

    _groupChannel = Supabase.instance.client
        .channel('group_$circleId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'circle_id',
            value: circleId,
          ),
          callback: (payload) {
            debugPrint('[Realtime] New group message received');

            final newMessage = GroupMessage.fromSupabase(
              messageRow: payload.newRecord,
              reactions: const [],
              replies: const [],
            );

            final exists = state.groupMessages.any(
              (m) => m.id == newMessage.id,
            );

            if (!exists) {
              add(GroupMessageInserted(newMessage));
            }
          },
        )
        .subscribe();
  }
}


