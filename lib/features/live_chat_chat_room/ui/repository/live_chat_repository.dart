import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';

class ChatRoomRepository {
  final SupabaseClient _supabase;

  ChatRoomRepository({SupabaseClient? supabase})
      : _supabase = supabase ?? Supabase.instance.client;

  String? get currentUserId => _supabase.auth.currentUser?.id;

  Future<void> sendTextMessage({
    required String roomId,
    required String text,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _supabase.from('messages').insert({
      'live_chat_room_id': roomId,
      'sender_id': user.id,
      'content': text,
      'media_type': 'text',
    });
  }

  Stream<List<ChatMessage>> streamMessages({
    required String roomId,
  }) {
    final userId = currentUserId ?? '';

    return _supabase
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('live_chat_room_id', roomId)
        .order('created_at')
        .map(
          (rows) => rows
              .map((row) => ChatMessage.fromMap(row, userId))
              .toList(),
        );
  }
}
