import 'dart:async';
import 'package:senior_circle/features/individual_chat/model/individual_user_profile_model.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/user_profile.dart';
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

Stream<List<ChatMessage>> streamMessages({required String roomId}) {
  final userId = currentUserId ?? '';

  return _supabase
      .from('messages')
      .stream(primaryKey: ['id'])
      .map((rows) {
        return rows
            .where((row) =>
                row['live_chat_room_id'] == roomId &&
                row['deleted_at'] == null) 
            .map((row) => ChatMessage.fromMap(row, userId))
            .toList();
      });
}



  Future<void> sendFriendRequest(String otherUserId) async {
    final userId = currentUserId;
    if (userId == null) throw Exception('User not logged in');

    await _supabase.from('friend_requests').insert({
      'sender_id': currentUserId,
      'receiver_id': otherUserId,
      'status': 'pending',
    });
  }

  Future<void> removeFriend(String requestId) async {
    await _supabase.from('friend_requests').delete().eq('id', requestId);
  }

  Future<Map<String, dynamic>?> getFriendRequest(String otherUserId) async {
    final userId = currentUserId;
    if (userId == null) return null;
    return await _supabase
        .from('friend_requests')
        .select()
        .or(
          'and(sender_id.eq.$currentUserId,receiver_id.eq.$otherUserId),'
          'and(sender_id.eq.$otherUserId,receiver_id.eq.$currentUserId)',
        )
        .maybeSingle();
  }
Future<ChatUserProfile?> getUserProfile(String userId) async {

  final data = await _supabase
      .from('users')
      .select('id, username, full_name, avatar_url, locations(name)')
      .eq('id', userId)
      .maybeSingle();

  if (data == null) return null;

 return ChatUserProfile(
  id: data['id']?.toString() ?? '',
  username: data['username']?.toString() ?? '',
  fullName: data['full_name']?.toString(),
  avatarUrl: data['avatar_url']?.toString(),
  locationName: data['locations']?['name']?.toString(),
);
 }



}
