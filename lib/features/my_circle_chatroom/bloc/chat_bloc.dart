import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/enum/chat_message_type.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
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
    : super(const ChatState(messages: [], groupMessages: [])) {
    on<LoadGroupMessages>(_onLoadGroupMessages);
    on<GroupMessageInserted>(_onGroupMessageInserted);
    on<SendGroupMessage>(_onSendGroupMessage);
    on<DeleteGroupMessage>(_onDeleteGroupMessage);
    on<GroupReactionChanged>(_onGroupReactionChanged);
    on<ToggleReaction>(_onToggleReaction);
    on<ToggleGroupThread>(_onToggleGroupThread);
    on<ToggleReplyInput>(_onToggleReplyInput);
    on<ToggleStar>(_onToggleStar);
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
      String? imageUrl;

      if (event.imagePath != null) {
        debugPrint('🟨 [ChatBloc] Uploading image...');
        imageUrl = await repository.uploadCircleImage(File(event.imagePath!));
        debugPrint('🟩 [ChatBloc] Image uploaded: $imageUrl');
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
      add(GroupMessageInserted(newMessage));
      
    } catch (e, st) {
      debugPrint('🟥 [ChatBloc] Error sending message: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  Future<void> _onDeleteGroupMessage(
    DeleteGroupMessage event,
    Emitter<ChatState> emit,
  ) async {
    final updatedMessages = state.groupMessages.where((m) {
      return m.id != event.messageId; 
    }).map((m) {
       if (m.replies.any((r) => r.id == event.messageId)) {
         return m.copyWith(
           replies: m.replies.where((r) => r.id != event.messageId).toList(),
         );
       }
       return m;
    }).toList();

    emit(state.copyWith(groupMessages: updatedMessages));

    if (event.forEveryone) {
      try {
        await repository.deleteGroupMessage(event.messageId);
        debugPrint('🗑️ [ChatBloc] Deleted message ${event.messageId} for everyone');
      } catch (e) {
        debugPrint('🟥 [ChatBloc] Delete failed: $e');
      }
    }
  }

  void _onToggleReaction(ToggleReaction event, Emitter<ChatState> emit) {
    if (event.type == ChatMessageType.individual) return;

    final updatedMessages = state.groupMessages.map((message) {
      return message.updateReaction(
        messageId: event.messageId,
        emoji: event.emoji,
        userId: event.userId,
        applyReactionFn: applyReaction,
      );
    }).toList();

    emit(state.copyWith(groupMessages: updatedMessages));

    repository.toggleGroupReaction(
      messageId: event.messageId,
      emoji: event.emoji,
      userId: event.userId,
    );
  }

  void _onToggleGroupThread(ToggleGroupThread event, Emitter<ChatState> emit) {
    final updatedGroupMessages = state.groupMessages.map((message) {
      if (message.id == event.messageId) {
        final willOpen = !message.isThreadOpen;

        return message.copyWith(
          isThreadOpen: willOpen,
          isReplyInputOpen: willOpen ? message.isReplyInputOpen : false,
        );
      }

      return message.copyWith(isThreadOpen: false, isReplyInputOpen: false);
    }).toList();

    emit(state.copyWith(groupMessages: updatedGroupMessages));

    debugPrint("🧵 [ChatBloc] Thread toggled: ${event.messageId}");
  }

  void _onToggleReplyInput(ToggleReplyInput event, Emitter<ChatState> emit) {
    final updatedGroupMessages = state.groupMessages.map((message) {
      if (message.id == event.messageId) {
        final willOpen = !message.isReplyInputOpen;

        return message.copyWith(
          isReplyInputOpen: willOpen,
          isThreadOpen: willOpen ? message.isThreadOpen : false,
        );
      }

      return message.copyWith(isReplyInputOpen: false);
    }).toList();

    emit(state.copyWith(groupMessages: updatedGroupMessages));

    debugPrint("💬 [ChatBloc] Reply input toggled: ${event.messageId}");
  }

  Future<void> _onToggleStar(ToggleStar event, Emitter<ChatState> emit) async {
    final targetMessage =
        _findMessageRecursive(state.groupMessages, event.messageId);

    if (targetMessage == null) return;


    final updatedMessages = state.groupMessages.map((msg) {
      return msg.toggleStar(event.messageId);
    }).toList();

    emit(state.copyWith(groupMessages: updatedMessages));


    try {
      await repository.toggleSaveMessage(message: targetMessage);
    } catch (e) {
      debugPrint('🟥 Failed to toggle star: $e');
    }
  }

  GroupMessage? _findMessageRecursive(List<GroupMessage> messages, String id) {
    for (final msg in messages) {
      if (msg.id == id) return msg;

      if (msg.replies.isNotEmpty) {
        final found = _findMessageRecursive(msg.replies, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  void _onGroupMessageInserted(
    GroupMessageInserted event,
    Emitter<ChatState> emit,
  ) {
    // 🟦 Parent message (optimization)
    if (event.message.replyToMessageId == null) {
      emit(state.copyWith(
          groupMessages: [event.message, ...state.groupMessages]));
      return;
    }

    // 🌳 Update recursively for replies
    final updatedMessages = state.groupMessages.map((msg) {
      return msg.addReply(event.message);
    }).toList();

    emit(state.copyWith(groupMessages: updatedMessages));
  }

  void _onGroupReactionChanged(
    GroupReactionChanged event,
    Emitter<ChatState> emit,
  ) {
    final updated = state.groupMessages.map((message) {
      return message.updateReaction(
        messageId: event.messageId,
        emoji: event.emoji,
        userId: event.userId,
        applyReactionFn: applyReaction,
      );
    }).toList();

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
            debugPrint('🟩 [Realtime] New group message received');

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


