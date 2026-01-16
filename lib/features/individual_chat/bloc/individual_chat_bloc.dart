import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senior_circle/features/individual_chat/model/individual_chat_message_model.dart';
import 'package:senior_circle/features/individual_chat/model/individual_message_reaction_model.dart';
import 'package:senior_circle/features/individual_chat/repositories/individual_chat_local_repository.dart';
import 'package:senior_circle/features/individual_chat/repositories/individual_chat_remote_repository.dart';

part 'individual_chat_event.dart';
part 'individual_chat_state.dart';

class IndividualChatBloc
    extends Bloc<IndividualChatEvent, IndividualChatState> {
  final IndividualChatLocalRepository _localRepository;
  final IndividualChatRemoteRepository _remoteRepository;

  late String _conversationId;

  IndividualChatBloc({
    required IndividualChatLocalRepository localRepository,
    required IndividualChatRemoteRepository remoteRepository,
  }) : _localRepository = localRepository,
       _remoteRepository = remoteRepository,
       super(IndividualChatInitial()) {
    on<LoadConversationMessages>(_onLoadMessages);
    on<PickMessageImage>(_onPickImage);
    on<RemovePickedImage>(_onRemoveImage);
    on<PickMessageFile>(_onPickFile);
    on<RemovePickedFile>(_onRemoveFile);
    on<PickReplyMessage>(_onPickReply);
    on<ClearReplyMessage>(_onClearReply);
    on<SendConversationMessage>(_onSendMessage);
    on<AddReactionToMessage>(_onAddReaction);
    on<RemoveReaction>(_onRemoveReaction);
    on<StarMessage>(_onStarMessage);
    on<DeleteMessageForEveryone>(_onDeleteMessageForEveryone);
    on<DeleteMessageForMe>(_onDeleteMessageForMe);
    on<SendVoiceMessage>(_onSendVoiceMessage);
  }

  // ---------------------------------------------------------------------------
  // LOAD MESSAGES
  // ---------------------------------------------------------------------------
  Future<void> _onLoadMessages(
    LoadConversationMessages event,
    Emitter<IndividualChatState> emit,
  ) async {
    _conversationId = event.conversationId;
    emit(IndividualChatLoading());

    try {
      // 1. Fetch from remote (Supabase)
      final remoteMessages = await _remoteRepository.fetchMessages(
        _conversationId,
      );

      // 2. Sync to local (Drift)
      for (final msg in remoteMessages) {
        await _localRepository.upsertMessage(msg, _conversationId);
      }

      // 3. Emit loaded state with messages
      emit(
        IndividualChatLoaded(
          messages: remoteMessages,
          imagePath: null,
          filePath: null,
          replyTo: null,
          isSending: false,
        ),
      );

      // 4. Subscribe to realtime changes
      _subscribeToRealtime();
    } catch (e) {
      // Fallback to local data if remote fetch fails
      try {
        final localMessages = await _localRepository.getMessagesSnapshot(
          _conversationId,
        );
        if (localMessages.isNotEmpty) {
          emit(
            IndividualChatLoaded(
              messages: localMessages,
              imagePath: null,
              filePath: null,
              replyTo: null,
              isSending: false,
            ),
          );
        } else {
          emit(IndividualChatError(e.toString()));
        }
      } catch (_) {
        emit(IndividualChatError(e.toString()));
      }
    }
  }

  // ---------------------------------------------------------------------------
  // IMAGE STATE
  // ---------------------------------------------------------------------------
  void _onPickImage(PickMessageImage event, Emitter emit) {
    if (state is! IndividualChatLoaded) return;
    emit(
      (state as IndividualChatLoaded).copyWith(
        imagePath: event.imagePath,
        clearFilePath: true,
      ),
    );
  }

  void _onRemoveImage(RemovePickedImage event, Emitter emit) {
    if (state is! IndividualChatLoaded) return;
    emit((state as IndividualChatLoaded).copyWith(clearImagePath: true));
  }

  // ---------------------------------------------------------------------------
  // FILE STATE
  // ---------------------------------------------------------------------------
  void _onPickFile(PickMessageFile event, Emitter emit) {
    if (state is! IndividualChatLoaded) return;
    final current = state as IndividualChatLoaded;

    emit(
      current.copyWith(
        filePath: event.path,
        clearImagePath: true, // optional: prevent both
      ),
    );
  }

  void _onRemoveFile(RemovePickedFile event, Emitter emit) {
    if (state is! IndividualChatLoaded) return;

    emit((state as IndividualChatLoaded).copyWith(clearFilePath: true));
  }

  // ---------------------------------------------------------------------------
  // REPLY STATE
  // ---------------------------------------------------------------------------
  void _onPickReply(PickReplyMessage event, Emitter emit) {
    if (state is! IndividualChatLoaded) return;
    emit((state as IndividualChatLoaded).copyWith(replyTo: event.message));
  }

  void _onClearReply(ClearReplyMessage event, Emitter emit) {
    if (state is! IndividualChatLoaded) return;
    emit((state as IndividualChatLoaded).copyWith(clearReplyTo: true));
  }

  // ---------------------------------------------------------------------------
  // SEND MESSAGE (OPTIMISTIC)
  // ---------------------------------------------------------------------------
  Future<void> _onSendMessage(
    SendConversationMessage event,
    Emitter<IndividualChatState> emit,
  ) async {
    if (state is! IndividualChatLoaded) return;
    final current = state as IndividualChatLoaded;

    final userId = await _remoteRepository.getCurrentUserId();
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    String? mediaUrl;
    String mediaType = 'text';

    try {
      emit(current.copyWith(isSending: true));

      /// ───────── MEDIA HANDLING ─────────
      if (current.imagePath != null) {
        mediaUrl = await _remoteRepository.uploadMedia(
          file: File(current.imagePath!),
          folder: 'images',
        );
        mediaType = 'image';
      } else if (current.filePath != null) {
        mediaUrl = await _remoteRepository.uploadMedia(
          file: File(current.filePath!),
          folder: 'files',
        );
        mediaType = 'file';
      }

      /// ───────── OPTIMISTIC MESSAGE ─────────
      final optimisticMessage = IndividualChatMessageModel(
        id: tempId,
        senderId: userId,
        content: event.text,
        mediaUrl: mediaUrl,
        mediaType: mediaType,
        createdAt: DateTime.now(),
        replyToMessageId:
            current.replyTo != null && !current.replyTo!.id.startsWith('temp_')
            ? current.replyTo!.id
            : null,
      );

      emit(
        current.copyWith(
          messages: [...current.messages, optimisticMessage],
          clearImagePath: true,
          clearFilePath: true,
          clearReplyTo: true,
          version: current.version + 1,
        ),
      );

      /// ───────── SEND TO REMOTE ─────────
      final realMessage = await _remoteRepository.insertMessage(
        conversationId: _conversationId,
        content: event.text,
        mediaType: mediaType,
        mediaUrl: mediaUrl,
        replyToMessageId: optimisticMessage.replyToMessageId,
      );

      /// ───────── SYNC TO LOCAL ─────────
      await _localRepository.upsertMessage(realMessage, _conversationId);

      /// ───────── REPLACE TEMP WITH REAL ─────────
      if (state is IndividualChatLoaded) {
        final live = state as IndividualChatLoaded;

        emit(
          live.copyWith(
            messages: live.messages
                .map((m) => m.id == tempId ? realMessage : m)
                .toList(),
            isSending: false,
          ),
        );
      }
    } catch (e) {
      emit(current.copyWith(isSending: false));
      emit(IndividualChatError(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // SEND VOICE MESSAGE
  // ---------------------------------------------------------------------------

  Future<void> _onSendVoiceMessage(
    SendVoiceMessage event,
    Emitter<IndividualChatState> emit,
  ) async {
    if (state is! IndividualChatLoaded) return;
    final current = state as IndividualChatLoaded;
    final userId = await _remoteRepository.getCurrentUserId();
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    emit(current.copyWith(isSending: true));

    try {
      /// ───── UPLOAD VOICE ─────
      final mediaUrl = await _remoteRepository.uploadMedia(
        file: event.audioFile,
        folder: 'voice',
      );

      /// ───── OPTIMISTIC MESSAGE ─────
      final optimistic = IndividualChatMessageModel(
        id: tempId,
        senderId: userId,
        content: '',
        mediaUrl: mediaUrl,
        mediaType: 'audio',
        createdAt: DateTime.now(),
        replyToMessageId:
            current.replyTo != null && !current.replyTo!.id.startsWith('temp_')
            ? current.replyTo!.id
            : null,
      );

      emit(
        current.copyWith(
          messages: [...current.messages, optimistic],
          clearReplyTo: true,
          version: current.version + 1,
        ),
      );

      /// ───── SEND TO REMOTE ─────
      final realMessage = await _remoteRepository.insertMessage(
        conversationId: _conversationId,
        mediaType: 'audio',
        mediaUrl: mediaUrl,
        replyToMessageId: optimistic.replyToMessageId,
      );

      /// ───── SYNC TO LOCAL ─────
      await _localRepository.upsertMessage(realMessage, _conversationId);

      /// ───── REPLACE TEMP WITH REAL ─────
      final live = state as IndividualChatLoaded;

      emit(
        live.copyWith(
          messages: live.messages
              .map((m) => m.id == tempId ? realMessage : m)
              .toList(),
          isSending: false,
          version: live.version + 1,
        ),
      );
    } catch (e) {
      emit(current.copyWith(isSending: false));
      emit(IndividualChatError(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // ADD REACTION
  // ---------------------------------------------------------------------------
  Future<void> _onAddReaction(
    AddReactionToMessage event,
    Emitter<IndividualChatState> emit,
  ) async {
    if (state is! IndividualChatLoaded) return;
    final current = state as IndividualChatLoaded;

    final userId = await _remoteRepository.getCurrentUserId();

    final updatedMessages = current.messages.map((m) {
      if (m.id != event.messageId) return m;

      final List<MessageReaction> updatedReactions = List<MessageReaction>.from(
        m.reactions,
      );

      final existingIndex = updatedReactions.indexWhere(
        (r) => r.userId == userId,
      );

      if (existingIndex != -1) {
        // Same reaction → toggle off
        if (updatedReactions[existingIndex].reaction == event.reaction) {
          updatedReactions.removeAt(existingIndex);
        } else {
          // Different reaction → replace
          updatedReactions[existingIndex] = MessageReaction(
            id: updatedReactions[existingIndex].id, // preserve temp/real id
            userId: userId,
            reaction: event.reaction,
          );
        }
      } else {
        // New reaction
        updatedReactions.add(
          MessageReaction(
            id: 'temp-${DateTime.now().millisecondsSinceEpoch}',
            userId: userId,
            reaction: event.reaction,
          ),
        );
      }

      return m.copyWith(reactions: updatedReactions);
    }).toList();

    // 🔥 CRITICAL: force rebuild
    emit(
      current.copyWith(messages: updatedMessages, version: current.version + 1),
    );

    try {
      /// ───── ADD TO REMOTE ─────
      final reactionData = await _remoteRepository.addReaction(
        messageId: event.messageId,
        reaction: event.reaction,
      );

      /// ───── SYNC TO LOCAL ─────
      if (reactionData != null) {
        // Reaction was added
        await _localRepository.upsertReaction(
          MessageReaction(
            id: reactionData['id'],
            userId: reactionData['user_id'],
            reaction: reactionData['reaction'],
          ),
          event.messageId,
          DateTime.parse(reactionData['created_at']),
        );
      } else {
        // Reaction was toggled off (deleted)
        await _localRepository.deleteReaction(
          event.messageId,
          userId,
          event.reaction,
        );
      }
    } catch (e) {
      // Optional rollback trigger
      if (state is IndividualChatLoaded) {
        final s = state as IndividualChatLoaded;
        emit(s.copyWith(version: s.version + 1));
      }
    }
  }

  // ---------------------------------------------------------------------------
  // REMOVE REACTION
  // ---------------------------------------------------------------------------
  Future<void> _onRemoveReaction(
    RemoveReaction event,
    Emitter<IndividualChatState> emit,
  ) async {
    if (state is! IndividualChatLoaded) return;
    final current = state as IndividualChatLoaded;

    final userId = await _remoteRepository.getCurrentUserId();

    final updatedMessages = current.messages.map((m) {
      if (m.id != event.messageId) return m;

      return m.copyWith(
        reactions: m.reactions
            .where((r) => !(r.reaction == event.reaction && r.userId == userId))
            .toList(),
      );
    }).toList();

    // 🔥 Optimistic UI update
    emit(
      current.copyWith(messages: updatedMessages, version: current.version + 1),
    );

    try {
      /// ───── REMOVE FROM REMOTE ─────
      await _remoteRepository.removeReaction(
        messageId: event.messageId,
        reaction: event.reaction,
      );

      /// ───── REMOVE FROM LOCAL ─────
      await _localRepository.deleteReaction(
        event.messageId,
        userId,
        event.reaction,
      );
    } catch (e) {
      emit(current); // rollback
    }
  }

  // ---------------------------------------------------------------------------
  // SAVE MESSAGES
  // ---------------------------------------------------------------------------
  Future<void> _onStarMessage(
    StarMessage event,
    Emitter<IndividualChatState> emit,
  ) async {
    if (state is! IndividualChatLoaded) return;
    final current = state as IndividualChatLoaded;

    try {
      await _remoteRepository.starMessage(message: event.message);

      emit(StarMessageSuccess('Message starred ⭐'));

      emit(current.copyWith());
    } catch (e) {
      emit(StarMessageFailure('Failed to star message'));
      emit(current.copyWith());
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE FOR EVERY ONE MESSAGES
  // ---------------------------------------------------------------------------

  Future<void> _onDeleteMessageForEveryone(
    DeleteMessageForEveryone event,
    Emitter<IndividualChatState> emit,
  ) async {
    if (state is! IndividualChatLoaded) return;
    final current = state as IndividualChatLoaded;

    final updatedMessages = current.messages
        .where((m) => m.id != event.message.id)
        .toList();

    emit(current.copyWith(messages: updatedMessages));

    try {
      /// ───── DELETE FROM REMOTE ─────
      await _remoteRepository.deleteMessageForEveryone(event.message.id);

      /// ───── SOFT DELETE LOCALLY ─────
      await _localRepository.softDeleteMessage(event.message.id);

      emit(DeleteMessageSuccess('Message deleted'));
      emit(current.copyWith(messages: updatedMessages));
    } catch (e) {
      emit(DeleteMessageFailure('Failed to delete message'));
      emit(current);
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE FOR ME MESSAGES
  // ---------------------------------------------------------------------------
  Future<void> _onDeleteMessageForMe(
    DeleteMessageForMe event,
    Emitter<IndividualChatState> emit,
  ) async {
    if (state is! IndividualChatLoaded) return;
    final current = state as IndividualChatLoaded;

    final updatedMessages = current.messages
        .where((m) => m.id != event.messageId)
        .toList();

    emit(current.copyWith(messages: updatedMessages));

    try {
      /// ───── DELETE FROM REMOTE ─────
      await _remoteRepository.deleteMessageForMe(event.messageId);

      /// ───── SOFT DELETE LOCALLY ─────
      await _localRepository.softDeleteMessage(event.messageId);

      emit(DeleteMessageSuccess('Message deleted'));
      emit(current.copyWith(messages: updatedMessages));
    } catch (e) {
      emit(DeleteMessageFailure('Failed to delete message'));
      emit(current);
    }
  }

  // ---------------------------------------------------------------------------
  // REALTIME MESSAGES
  // ---------------------------------------------------------------------------
  void _subscribeToRealtime() {
    // Subscribe to new messages
    _remoteRepository.subscribeToMessagesRealtime(_conversationId, (
      newMessage,
    ) async {
      if (state is! IndividualChatLoaded) return;

      final live = state as IndividualChatLoaded;

      // Check if message already exists
      if (live.messages.any((m) => m.id == newMessage.id)) return;

      // Sync new message to local DB
      await _localRepository.upsertMessage(newMessage, _conversationId);

      // Update UI immediately
      // ignore: invalid_use_of_visible_for_testing_member
      emit(live.copyWith(messages: [...live.messages, newMessage]));
    });

    // Subscribe to reaction changes
    _remoteRepository.subscribeToReactionsRealtime(_conversationId, (
      reactionData,
      isDelete,
    ) async {
      if (isDelete) {
        // Delete reaction from local DB
        await _localRepository.deleteReaction(
          reactionData['message_id'],
          reactionData['user_id'],
          reactionData['reaction'],
        );
      } else {
        // Add reaction to local DB
        await _localRepository.upsertReaction(
          MessageReaction(
            id: reactionData['id'],
            userId: reactionData['user_id'],
            reaction: reactionData['reaction'],
          ),
          reactionData['message_id'],
          DateTime.parse(reactionData['created_at']),
        );
      }
      // Note: Reactions will be picked up on next message load or we could emit state here
    });
  }

  // ---------------------------------------------------------------------------
  // CLEANUP
  // ---------------------------------------------------------------------------
  @override
  Future<void> close() {
    _remoteRepository.unsubscribeFromRealtime();
    return super.close();
  }
}
