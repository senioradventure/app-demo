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
    on<DeleteMessage>(_onDeleteMessage);
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
        debugPrint('🟩 [ChatBloc] Image uploaded');
        debugPrint('🟩 [ChatBloc] Image URL: $imageUrl');
      }

      debugPrint('🟨 [ChatBloc] Sending message to database');

      await repository.sendGroupMessage(
        circleId: circleId,
        content: event.text ?? '',
        mediaUrl: imageUrl,
        mediaType: imageUrl != null ? 'image' : 'text',
        replyToMessageId: event.replyToMessageId,
      );

      debugPrint('🟩 [ChatBloc] Message sent successfully');

      debugPrint('🟨 [ChatBloc] Reloading group messages');

      final messages = await repository.fetchGroupMessages(circleId: circleId);

      debugPrint('🟩 [ChatBloc] Messages reloaded: ${messages.length}');

      emit(state.copyWith(groupMessages: messages));
    } catch (e, st) {
      debugPrint('🟥 [ChatBloc] Error sending message: $e');
      debugPrintStack(stackTrace: st);
    }
  }

  void _onDeleteMessage(DeleteMessage event, Emitter<ChatState> emit) {
    final updatedMessages = state.messages
        .where((m) => m.id != event.messageId)
        .toList();

    emit(state.copyWith(messages: updatedMessages));
  }

  void _onToggleReaction(ToggleReaction event, Emitter<ChatState> emit) {
    if (event.type == ChatMessageType.individual) return;

    final updatedMessages = state.groupMessages.map((message) {
      return _applyReactionRecursive(
        message,
        event.messageId,
        event.emoji,
        event.userId,
        true,
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

  void _onToggleStar(ToggleStar event, Emitter<ChatState> emit) {}

  void _onGroupMessageInserted(
    GroupMessageInserted event,
    Emitter<ChatState> emit,
  ) {
    final msg = event.message;

    // 🟦 Parent message
    if (msg.replyToMessageId == null) {
      emit(state.copyWith(groupMessages: [msg, ...state.groupMessages]));
      return;
    }

    final updatedMessages = state.groupMessages.map((parent) {
      if (parent.id == msg.replyToMessageId) {
        return parent.copyWith(replies: [...parent.replies, msg]);
      }
      return parent;
    }).toList();

    emit(state.copyWith(groupMessages: updatedMessages));
  }

  void _onGroupReactionChanged(
    GroupReactionChanged event,
    Emitter<ChatState> emit,
  ) {
    final updated = state.groupMessages.map((message) {
      return _applyReactionRecursive(
        message,
        event.messageId,
        event.emoji,
        event.userId,
        event.isAdded,
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

GroupMessage _applyReactionRecursive(
  GroupMessage message,
  String targetMessageId,
  String emoji,
  String userId,
  bool isAdded,
) {
  // 🎯 Match found
  if (message.id == targetMessageId) {
    return applyReaction(
      message: message,
      targetMessageId: targetMessageId,
      emoji: emoji,
      userId: userId,
    );
  }

  // 🔁 Recurse into replies
  if (message.replies.isNotEmpty) {
    return message.copyWith(
      replies: message.replies
          .map(
            (reply) => _applyReactionRecursive(
              reply,
              targetMessageId,
              emoji,
              userId,
              isAdded,
            ),
          )
          .toList(),
    );
  }

  return message;
}
