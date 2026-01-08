import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';

part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final SupabaseClient _supabase;
  final _uuid = const Uuid();

  StreamSubscription<List<Map<String, dynamic>>>? _messagesSub;

  ChatRoomBloc({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client,
        super(const ChatRoomState(isLoading: true)) {
    on<ChatRoomStarted>(_onStarted);
    on<ChatMessageSendRequested>(_onSendMessage);
    on<ChatImageSelected>(_onImageSelected);
    on<ChatImageCleared>(_onImageCleared);
    on<ChatMessagesUpdated>(_onMessagesUpdated);
    on<ChatRoomErrorOccurred>(_onError);
  }

 
  Future<void> _onStarted(
  ChatRoomStarted event,
  Emitter<ChatRoomState> emit,
) async {
  emit(state.copyWith(isLoading: true));

  await _messagesSub?.cancel();

  final currentUserId = _supabase.auth.currentUser?.id ?? '';

  _messagesSub = _supabase
      .from('messages')
      .stream(primaryKey: ['id'])
      .eq('live_chat_room_id', event.roomId)
      .order('created_at')
      .listen(
    (rows) {
      final incoming = rows
          .map((row) => ChatMessage.fromMap(row, currentUserId))
          .toList();

      add(ChatMessagesUpdated(incoming));
    },
    onError: (e) {
      add(ChatRoomErrorOccurred(e.toString()));
    },
  );
}


  void _onMessagesUpdated(
    ChatMessagesUpdated event,
    Emitter<ChatRoomState> emit,
  ) {
    final merged = <ChatMessage>[];


    for (final local in state.messages) {
      final exists =
          event.messages.any((server) => server.id == local.id);
      if (!exists) merged.add(local);
    }

    merged.addAll(event.messages);

    emit(state.copyWith(
      messages: merged,
      isLoading: false,
    ));
  }
  Future<void> _onSendMessage(
    ChatMessageSendRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final tempId = _uuid.v4();
    final now = DateTime.now();

    final optimistic = ChatMessage(
      id: tempId,
      isSender: true,
      text: event.text,
      time: _formatTime(now),
      imageFile: event.imagePath,
      name: 'You',
      profileAsset: null,
    );

    emit(state.copyWith(
      messages: [...state.messages, optimistic],
      isSending: true,
      pendingImage: null,
    ));

    try {
      String? mediaUrl;
      String mediaType = 'text';

      if (event.imagePath != null) {
        final file = File(event.imagePath!);
        final ext = event.imagePath!.split('.').last;
        final name = 'messages/${_uuid.v4()}.$ext';

        await _supabase.storage.from('media').upload(name, file);
        mediaUrl = _supabase.storage.from('media').getPublicUrl(name);
        mediaType = 'image';
      }

      await _supabase.from('messages').insert({
        'id': tempId,
        'sender_id': user.id,
        'content': event.text,
        'media_type': mediaType,
        'media_url': mediaUrl,
      });

      emit(state.copyWith(isSending: false));
    } catch (e) {
      emit(state.copyWith(
        isSending: false,
        messages:
            state.messages.where((m) => m.id != tempId).toList(),
        error: e.toString(),
      ));
    }
  }


  void _onImageSelected(
    ChatImageSelected event,
    Emitter<ChatRoomState> emit,
  ) {
    emit(state.copyWith(pendingImage: event.imagePath));
  }


  void _onImageCleared(
    ChatImageCleared event,
    Emitter<ChatRoomState> emit,
  ) {
    emit(state.copyWith(pendingImage: null));
  }


  void _onError(
    ChatRoomErrorOccurred event,
    Emitter<ChatRoomState> emit,
  ) {
    emit(state.copyWith(error: event.message));
  }

  @override
  Future<void> close() {
    _messagesSub?.cancel();
    return super.close();
  }


  String _formatTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final hour =
        local.hour > 12 ? local.hour - 12 : (local.hour == 0 ? 12 : local.hour);
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
