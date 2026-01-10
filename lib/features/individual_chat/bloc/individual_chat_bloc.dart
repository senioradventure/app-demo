import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:senior_circle/features/individual_chat/model/individual_chat_message_model.dart';
import 'package:senior_circle/features/individual_chat/model/individual_message_reaction_model.dart';
import 'package:senior_circle/features/individual_chat/repositories/individual_chat_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'individual_chat_event.dart';
part 'individual_chat_state.dart';

class IndividualChatBloc
    extends Bloc<IndividualChatEvent, IndividualChatState> {
  final SupabaseClient _client = Supabase.instance.client;
  final IndividualChatRepository _repository;

  late String _conversationId;
  RealtimeChannel? _channel;

  String? _prefilledText;
  String? _prefilledMedia;

  IndividualChatBloc(this._repository) : super(IndividualChatInitial()) {
    on<LoadConversationMessages>(_onLoadMessages);
    on<PickMessageImage>(_onPickImage);
    on<RemovePickedImage>(_onRemoveImage);
    on<PickReplyMessage>(_onPickReply);
    on<ClearReplyMessage>(_onClearReply);
    on<SendConversationMessage>(_onSendMessage);
    on<AddReactionToMessage>(_onAddReaction);
    on<StarMessage>(_onStarMessage);
    on<DeleteMessageForEveryone>(_onDeleteMessageForEveryone);
    on<DeleteMessageForMe>(_onDeleteMessageForMe);
    on<PrefillIndividualChat>(_onPrefillChat);
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
      final messages = await _repository.loadMessages(_conversationId);

      emit(
        IndividualChatLoaded(
          messages: messages,
          imagePath: null,
          replyTo: null,
          isSending: false,
          prefilledInputText: _prefilledText,
          prefilledMediaUrl: _prefilledMedia,
        ),
      );

      // Clear after applying to initial state
      _prefilledText = null;
      _prefilledMedia = null;

      _subscribeToRealtime();
    } catch (e) {
      debugPrint(e.toString());
      emit(IndividualChatError(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // IMAGE STATE
  // ---------------------------------------------------------------------------
  void _onPickImage(PickMessageImage event, Emitter emit) {
    if (state is! IndividualChatLoaded) return;
    emit((state as IndividualChatLoaded).copyWith(imagePath: event.imagePath));
  }

  void _onRemoveImage(RemovePickedImage event, Emitter emit) {
    if (state is! IndividualChatLoaded) return;
    emit((state as IndividualChatLoaded).copyWith(clearImagePath: true));
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

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    String? mediaUrl = current.prefilledMediaUrl;

    try {
      emit(current.copyWith(isSending: true));

      // IMAGE UPLOAD (if local file picked)
      if (current.imagePath != null) {
        if (current.imagePath!.startsWith('http')) {
          debugPrint('🟨 [IndividualChatBloc] imagePath is a URL, skipping upload');
          mediaUrl = current.imagePath;
        } else {
          debugPrint('🟨 [IndividualChatBloc] Uploading image...');
          final file = File(current.imagePath!);
          final fileName =
              'messages/${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';

          await _client.storage.from('media').upload(fileName, file);
          mediaUrl = _client.storage.from('media').getPublicUrl(fileName);
        }
      }

      // OPTIMISTIC MESSAGE
      final optimisticMessage = IndividualChatMessageModel(
        id: tempId,
        senderId: _client.auth.currentUser!.id,
        content: event.text,
        mediaUrl: mediaUrl,
        mediaType: mediaUrl == null ? 'text' : 'image',
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
          clearReplyTo: true,
          prefilledMediaUrl: null, // Clear after use
        ),
      );

      // INSERT REAL MESSAGE
      final response = await _client
          .from('messages')
          .insert({
            'conversation_id': _conversationId,
            'sender_id': _client.auth.currentUser!.id,
            'content': event.text,
            'media_url': mediaUrl,
            'media_type': mediaUrl == null ? 'text' : 'image',
            'reply_to_message_id': optimisticMessage.replyToMessageId,
          })
          .select()
          .single();

      final realMessage = IndividualChatMessageModel.fromSupabase(response);

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

    final userId = _client.auth.currentUser!.id;

    /// 🔥 UPDATE UI IMMEDIATELY
    final updatedMessages = current.messages.map((m) {
      if (m.id != event.messageId) return m;

      final existingIndex = m.reactions.indexWhere((r) => r.userId == userId);

      List<MessageReaction> updatedReactions = List.from(m.reactions);

      if (existingIndex != -1) {
        if (updatedReactions[existingIndex].reaction == event.reaction) {
          updatedReactions.removeAt(existingIndex); // toggle off
        } else {
          updatedReactions[existingIndex] = MessageReaction(
            id: 'temp',
            userId: userId,
            reaction: event.reaction,
          );
        }
      } else {
        updatedReactions.add(
          MessageReaction(id: 'temp', userId: userId, reaction: event.reaction),
        );
      }

      return m.copyWith(reactions: updatedReactions);
    }).toList();

    emit(current.copyWith(messages: updatedMessages));

    /// 🔥 THEN UPDATE DATABASE
    await _repository.addReaction(
      messageId: event.messageId,
      reaction: event.reaction,
    );
  }

  // ---------------------------------------------------------------------------
  // SAVE MESSAGES
  // ---------------------------------------------------------------------------
  Future<void> _onStarMessage(
    StarMessage event,
    Emitter<IndividualChatState> emit,
  ) async {
    if (state is! IndividualChatLoaded) return; // Ensure we have chat loaded
    final current = state as IndividualChatLoaded;

    try {
      await _repository.starMessage(message: event.message);

      // Emit ONE-TIME snackbar without replacing the chat state
      emit(StarMessageSuccess('Message starred ⭐'));

      // Immediately restore chat state so UI doesn't break
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
      await _client
          .from('messages')
          .update({'deleted_at': DateTime.now().toUtc().toIso8601String()})
          .eq('id', event.message.id);

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

    // Optimistically remove from UI
    final updatedMessages = current.messages
        .where((m) => m.id != event.messageId)
        .toList();

    emit(current.copyWith(messages: updatedMessages));

    try {
      await _repository.deleteMessageForMe(event.messageId);
      // Success - no need to emit again since UI already updated
    } catch (e) {
      debugPrint('Delete error: $e'); // Debug logging
      // Rollback on failure
      emit(DeleteMessageFailure('Failed to delete message: ${e.toString()}'));
      emit(
        current.copyWith(),
      ); // Restore original messages with version increment
    }
  }

  // ---------------------------------------------------------------------------
  // REALTIME MESSAGES
  // ---------------------------------------------------------------------------
  void _subscribeToRealtime() {
    _channel?.unsubscribe();

    _channel = _client
        .channel('conversation_$_conversationId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: _conversationId,
          ),
          callback: (payload) {
            if (state is! IndividualChatLoaded) return;

            final newMessage = IndividualChatMessageModel.fromSupabase(
              payload.newRecord,
            );

            final live = state as IndividualChatLoaded;

            if (live.messages.any((m) => m.id == newMessage.id)) return;

            emit(live.copyWith(messages: [...live.messages, newMessage]));
          },
        )
        .subscribe();
  }

  // ---------------------------------------------------------------------------
  // CLEANUP
  // ---------------------------------------------------------------------------
  @override
  Future<void> close() {
    _channel?.unsubscribe();
    return super.close();
  }

  void _onPrefillChat(
    PrefillIndividualChat event,
    Emitter<IndividualChatState> emit,
  ) {
    _prefilledText = event.text;
    _prefilledMedia = event.mediaUrl;

    if (state is! IndividualChatLoaded) return;
    final current = state as IndividualChatLoaded;

    emit(
      current.copyWith(
        prefilledInputText: _prefilledText,
        prefilledMediaUrl: _prefilledMedia,
      ),
    );

    // Clear after emitting state
    _prefilledText = null;
    _prefilledMedia = null;
  }
}
