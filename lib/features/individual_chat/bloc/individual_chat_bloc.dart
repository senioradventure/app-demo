import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as path;
import 'package:senior_circle/features/individual_chat/model/individual_chat_message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'individual_chat_event.dart';
part 'individual_chat_state.dart';

class IndividualChatBloc
    extends Bloc<IndividualChatEvent, IndividualChatState> {
  final SupabaseClient _client = Supabase.instance.client;

  late String _conversationId;
  RealtimeChannel? _channel;

  IndividualChatBloc() : super(IndividualChatInitial()) {
    on<LoadConversationMessages>(_onLoadMessages);
    on<PickMessageImage>(_onPickImage);
    on<RemovePickedImage>(_onRemoveImage);
    on<PickReplyMessage>(_onPickReply);
    on<ClearReplyMessage>(_onClearReply);
    on<SendConversationMessage>(_onSendMessage);
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
      final response = await _client
          .from('messages')
          .select()
          .eq('conversation_id', _conversationId)
          .isFilter('deleted_at', null)
          .order('created_at', ascending: true);

      final messages = (response as List)
          .map((e) => IndividualChatMessageModel.fromSupabase(e))
          .toList();

      emit(
        IndividualChatLoaded(
          messages: messages,
          imagePath: null,
          replyTo: null,
          isSending: false,
        ),
      );

      _subscribeToRealtime();
    } catch (e) {
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
  // SEND MESSAGE (OPTIMISTIC → REMOVE TEMP → REALTIME ADDS REAL)
  // ---------------------------------------------------------------------------
  Future<void> _onSendMessage(
    SendConversationMessage event,
    Emitter<IndividualChatState> emit,
  ) async {
    if (state is! IndividualChatLoaded) return;
    final current = state as IndividualChatLoaded;

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    String? uploadedImageUrl;

    try {
      emit((state as IndividualChatLoaded).copyWith(isSending: true));

      /// ---------------- IMAGE UPLOAD ----------------
      if (current.imagePath != null) {
        final file = File(current.imagePath!);
        final fileName =
            'messages/${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';

        await _client.storage.from('media').upload(fileName, file);
        uploadedImageUrl = _client.storage.from('media').getPublicUrl(fileName);
      }

      /// ---------------- OPTIMISTIC MESSAGE ----------------
      final optimisticMessage = IndividualChatMessageModel(
        id: tempId,
        senderId: _client.auth.currentUser!.id,
        content: event.text,
        mediaUrl: uploadedImageUrl,
        mediaType: uploadedImageUrl == null ? 'text' : 'image',
        createdAt: DateTime.now(),
        replyToMessageId:
            current.replyTo != null && !current.replyTo!.id.startsWith('temp_')
            ? current.replyTo!.id
            : null,
      );

      final optimisticMessages = [
        ...(state as IndividualChatLoaded).messages,
        optimisticMessage,
      ];

      emit(
        (state as IndividualChatLoaded).copyWith(
          messages: optimisticMessages,
          clearImagePath: true,
          clearReplyTo: true,
        ),
      );

      /// ---------------- INSERT INTO DB & GET REAL DATA ----------------
      final response = await _client
          .from('messages')
          .insert({
            'conversation_id': _conversationId,
            'sender_id': _client.auth.currentUser!.id,
            'content': event.text,
            'media_url': uploadedImageUrl,
            'media_type': uploadedImageUrl == null ? 'text' : 'image',
            'reply_to_message_id':
                optimisticMessage.replyToMessageId, // already safe
          })
          .select()
          .single();

      final realMessage = IndividualChatMessageModel.fromSupabase(response);

      /// ---------------- REPLACE OPTIMISTIC WITH REAL ----------------
      if (state is IndividualChatLoaded) {
        final live = state as IndividualChatLoaded;

        // Replace the temp message with real message
        final updatedMessages = live.messages
            .map((m) => m.id == tempId ? realMessage : m)
            .toList();

        emit(live.copyWith(messages: updatedMessages, isSending: false));
      }
    } catch (e) {
      emit(IndividualChatError(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // REALTIME (ONLY REAL DB MESSAGES ENTER UI)
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

            /// Prevent duplicates
            final exists = live.messages.any((m) => m.id == newMessage.id);

            if (exists) return;

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
}
