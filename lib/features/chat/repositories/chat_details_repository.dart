import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_details_models.dart';

import 'package:senior_circle/features/view_friends/models/friends_model.dart';

class ChatDetailsRepository {
  final SupabaseClient _supabase;

  ChatDetailsRepository(this._supabase);

  Future<List<Friend>> getFriends(String userId) async {
    try {
      final response = await _supabase.rpc(
        'get_friends',
        params: {'user_id': userId},
      );

      if (response == null) {
        return [];
      }

      final data = response as List;
      return data.map((json) => Friend.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching friends: $e');
      return [];
    }
  }

  Future<void> addMembersToCircle(
    String circleId,
    List<String> memberIds,
  ) async {
    if (memberIds.isEmpty) return;

    final List<Map<String, dynamic>> payload = memberIds
        .map(
          (id) => {
            'circle_id': circleId,
            'user_id': id,
            'role': 'member',
            'joined_at': DateTime.now().toIso8601String(),
          },
        )
        .toList();

    await _supabase.from('circle_members').insert(payload);
  }

  Future<ChatDetailsModel> getChatDetails(String chatId, ChatType type) async {
    if (type == ChatType.room) {
      final response = await _supabase
          .from('live_chat_rooms')
          .select()
          .eq('id', chatId)
          .single();
      return RoomDetails.fromJson(response);
    } else {
      final response = await _supabase
          .from('circles')
          .select()
          .eq('id', chatId)
          .single();
      return CircleDetails.fromJson(response);
    }
  }

  Future<List<ChatMember>> getChatMembers(String chatId, ChatType type) async {
    if (type == ChatType.room) {
      // live_chat_participants table linked with profiles
      // We need to fetch participants and then their profile details
      // Or use a join if RLS/Permissions allow. Assuming standard Supabase join.

      final response = await _supabase
          .from('live_chat_participants')
          .select('*, profiles(*)')
          .eq('room_id', chatId);

      // Note: room participants might not have a 'role' column in live_chat_participants
      // based on typical simple chat apps, but if they do, we use it.
      // If not, we might check if they match the admin_id of the room separately if needed,
      // but for now let's assume basic member role unless specified.

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => ChatMember.fromJson(json)).toList();
    } else {
      // circle_members linked with profiles
      final response = await _supabase
          .from('circle_members')
          .select('*, profiles(*)')
          .eq('circle_id', chatId);

      final List<dynamic> data = response as List<dynamic>;
      return data
          .map((json) => ChatMember.fromJson(json, isCircle: true))
          .toList();
    }
  }
}
