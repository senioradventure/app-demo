import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/constants/media_type.dart';
import 'package:senior_circle/features/circle_chat/models/circle_chat_message_model.dart';
import 'package:senior_circle/features/circle_chat/models/circle_chat_extensions.dart';
import 'package:senior_circle/core/utils/reaction_utils.dart';
import 'package:senior_circle/features/circle_chat/repositories/circle_chat_messages_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'circle_chat_event.dart';
import 'circle_chat_state.dart';

class CircleChatBloc extends Bloc<CircleChatEvent, CircleChatState> {
  final CircleChatMessagesRepository repository;
  String? _circleId;
  RealtimeChannel? _groupChannel;

  CircleChatBloc({required this.repository})
    : super(const CircleChatState(groupMessages: [])) {
    // Message Management
    on<LoadGroupMessages>(_onLoadGroupMessages);
    on<GroupMessageInserted>(_onGroupMessageInserted);
    on<SendGroupMessage>(_onSendGroupMessage);
    on<DeleteGroupMessage>(_onDeleteGroupMessage);
    
    // Message Interactions
    on<GroupReactionChanged>(_onGroupReactionChanged);
    on<ToggleReaction>(_onToggleReaction);
    on<ToggleGroupThread>(_onToggleGroupThread);
    on<ToggleReplyInput>(_onToggleReplyInput);
    on<ToggleStar>(_onToggleStar);
    
    // Message Forwarding
    on<ForwardMessage>(_onForwardMessage);
    on<ClearForwardingState>(_onClearForwardingState); 
    
    // Media Handling
    on<PickMessageImage>(_onPickMessageImage);
    on<PickMessageFile>(_onPickMessageFile);
    on<RemovePickedImage>(_onRemovePickedImage);
    on<RemovePickedFile>(_onRemovePickedFile);
    on<SendVoiceMessage>(_onSendVoiceMessage);

  }

  // ==================== Helper Methods ====================
  
  /// Upload media from state and return URL with type
  Future<(String url, String type)?> _uploadMedia() async {
    if (state.imagePath != null) {
      final url = await repository.uploadCircleImage(File(state.imagePath!));
      return (url, MediaType.image);
    }
    if (state.filePath != null) {
      final url = await repository.uploadFile(File(state.filePath!));
      return (url, MediaType.file);
    }
    return null;
  }

  /// Clear all media-related state fields
  CircleChatState _clearMediaState(CircleChatState currentState) {
    return currentState.copyWith(
      imagePath: null,
      filePath: null,
      prefilledInputText: null,
      prefilledMedia: null,
    );
  }

  // ==================== Event Handlers ====================

  Future<void> _onLoadGroupMessages(
    LoadGroupMessages event,
    Emitter<CircleChatState> emit,
  ) async {
    _circleId = event.chatId;

    try {
      // 🚀 Load from local DB first (instant)
      final localMessages = await repository.fetchMessagesFromLocal(event.chatId);
      if (localMessages.isNotEmpty) {
        debugPrint('🟦 [ChatBloc] Loaded ${localMessages.length} messages from local DB');
        emit(state.copyWith(groupMessages: localMessages, isLoading: false));
      } else {
        // Only show loading if no local data
        emit(state.copyWith(isLoading: true, error: null));
      }

      // 🔄 Sync with Supabase in background
      final messages = await repository.fetchGroupMessages(
        circleId: event.chatId,
      );

      debugPrint('🟩 [ChatBloc] Synced ${messages.length} messages from Supabase');
      emit(state.copyWith(groupMessages: messages, isLoading: false));

      _subscribeToGroupRealtime(event.chatId);
    } catch (e) {
      debugPrint('🟥 [ChatBloc] Error loading messages: $e');
      emit(state.copyWith(isLoading: false, error: 'Failed to load messages'));
    }
  }

  Future<void> _onSendGroupMessage(
    SendGroupMessage event,
    Emitter<CircleChatState> emit,
  ) async {
    final currentUser = repository.currentUserId;

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

      String? mediaUrl;
      String mediaType = MediaType.text;

      // Upload media from state if present
      final uploadedMedia = await _uploadMedia();
      if (uploadedMedia != null) {
        mediaUrl = uploadedMedia.$1;
        mediaType = uploadedMedia.$2;
      }
      // Use event imagePath if provided (for forwarding/prefilled)
      else if (event.imagePath != null) {
        debugPrint('🟨 [ChatBloc] Using event.imagePath: ${event.imagePath}');
        debugPrint('🟨 [ChatBloc] event.mediaType: ${event.mediaType}');
        mediaUrl = event.imagePath;
        if (event.mediaType != null) {
          mediaType = event.mediaType!;
        } else {
           final lowerUrl = event.imagePath!.toLowerCase();
           final isImage = ['jpg', 'jpeg', 'png', 'gif', 'webp'].any((ext) => lowerUrl.contains(ext));
           mediaType = isImage ? MediaType.image : MediaType.file;
        }
        debugPrint('🟨 [ChatBloc] Final mediaType: $mediaType');
      }

      debugPrint('🟨 [ChatBloc] Sending with mediaUrl: $mediaUrl, mediaType: $mediaType');

      final newMessage = await repository.sendGroupMessage(
        circleId: circleId,
        content: event.text ?? '',
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        replyToMessageId: event.replyToMessageId,
      );

      debugPrint('🟩 [ChatBloc] Message sent successfully');
      emit(_clearMediaState(state.copyWith(isSending: false)));
      add(GroupMessageInserted(newMessage));
      
    } catch (e, st) {
      debugPrint('🟥 [ChatBloc] Error sending message: $e');
      debugPrintStack(stackTrace: st);
      emit(state.copyWith(isSending: false, error: 'Failed to send message: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteGroupMessage(
    DeleteGroupMessage event,
    Emitter<CircleChatState> emit,
  ) async {
    final previousState = state;

    final updatedMessages = state.groupMessages
        .map((m) => m.removeRecursive(event.messageId))
        .whereType<CircleChatMessage>()
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

  void _onToggleReaction(ToggleReaction event, Emitter<CircleChatState> emit) {
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

  void _onToggleGroupThread(ToggleGroupThread event, Emitter<CircleChatState> emit) {
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

  void _onToggleReplyInput(ToggleReplyInput event, Emitter<CircleChatState> emit) {
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

  Future<void> _onToggleStar(ToggleStar event, Emitter<CircleChatState> emit) async {
    final targetMessage = _findMessageInList(state.groupMessages, event.messageId);
    if (targetMessage == null) return;

    final updatedMessages = _updateMessageInList(
      state.groupMessages,
      event.messageId,
      (msg) => msg.toggleStar(event.messageId),
    );

    emit(state.copyWith(groupMessages: updatedMessages));
    try {
      if (_circleId != null) {
        await repository.toggleSaveMessage(
          message: targetMessage,
          source: _circleId,
          sourceType: 'circle',
        );
      }
    } catch (e) {
      debugPrint('Failed to toggle star: $e');
    }
  }

  Future<void> _onForwardMessage(
    ForwardMessage event,
    Emitter<CircleChatState> emit,
  ) async {
    debugPrint('🟦 [Forward] ForwardMessage triggered');

    final message = event.message;
    final individualTargets = event.individualTargets;
    final circles = event.circleIds;

    debugPrint('🟦 [Forward] Individual count: ${individualTargets.length}, Circle count: ${circles.length}');

    final payload = _buildForwardPayload(message);

    //single recipient pre-fill
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

    // Multi-forward logic
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

  Map<String, dynamic> _buildForwardPayload(CircleChatMessage message) {
    debugPrint('🟦 [Forward] Building forward payload');
    
    return {
      'content': message.text,         
      'media_url': message.imagePath,
      'media_type': message.mediaType,
    };
  }

  CircleChatMessage? _findMessageInList(List<CircleChatMessage> messages, String id) {
    for (final msg in messages) {
      final found = msg.findRecursive(id);
      if (found != null) return found;
    }
    return null;
  }

  List<CircleChatMessage> _updateMessageInList(
    List<CircleChatMessage> messages,
    String targetId,
    CircleChatMessage Function(CircleChatMessage) updateFn, {
    bool clearOthers = false,
  }) {
    return messages
        .map((m) => m.updateRecursive(targetId, updateFn, clearOthers: clearOthers))
        .toList();
  }

  void _onGroupMessageInserted(
    GroupMessageInserted event,
    Emitter<CircleChatState> emit,
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
    Emitter<CircleChatState> emit,
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

    _groupChannel = repository.subscribeToGroupMessages(
      circleId: circleId,
      onMessageReceived: (payload) {
        debugPrint('[Realtime] New group message received');

        final newMessage = CircleChatMessage.fromSupabase(
          messageRow: payload,
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
    );
  }
  void _onClearForwardingState(
    ClearForwardingState event,
    Emitter<CircleChatState> emit,
  ) {
    emit(state.copyWith(
      prefilledInputText: null,
      prefilledMedia: null,
    ));
  }

  // ==================== Media Handlers ====================
  
  void _onPickMessageImage(
    PickMessageImage event,
    Emitter<CircleChatState> emit,
  ) {
    emit(state.copyWith(imagePath: event.imagePath));
  }

  void _onPickMessageFile(
    PickMessageFile event,
    Emitter<CircleChatState> emit,
  ) {
    emit(state.copyWith(filePath: event.filePath));
  }

  void _onRemovePickedImage(
    RemovePickedImage event,
    Emitter<CircleChatState> emit,
  ) {
    emit(state.copyWith(imagePath: null));
  }

  void _onRemovePickedFile(
    RemovePickedFile event,
    Emitter<CircleChatState> emit,
  ) {
    emit(state.copyWith(filePath: null));
  }

  Future<void> _onSendVoiceMessage(
    SendVoiceMessage event,
    Emitter<CircleChatState> emit,
  ) async {
    final circleId = _circleId;
    if (circleId == null) {
      debugPrint('🟥 [ChatBloc] circleId is NULL');
      return;
    }

    try {
      emit(state.copyWith(isSending: true));
      
      // Upload audio file
      final audioUrl = await repository.uploadAudio(File(event.audioFile));
      
      // Send message with audio
      final newMessage = await repository.sendGroupMessage(
        circleId: circleId,
        content: '',
        mediaUrl: audioUrl,
        mediaType: MediaType.audio,
      );

      emit(state.copyWith(isSending: false));
      add(GroupMessageInserted(newMessage));
    } catch (e) {
      debugPrint('🟥 [ChatBloc] Error sending voice message: $e');
      emit(state.copyWith(isSending: false, error: 'Failed to send voice message: ${e.toString()}'));
    }
  }
}


