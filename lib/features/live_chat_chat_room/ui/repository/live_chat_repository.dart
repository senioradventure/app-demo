import 'dart:async';
import 'package:flutter/material.dart';
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

    final response = await _supabase
        .from('messages')
        .insert({
          'live_chat_room_id': roomId,
          'sender_id': user.id,
          'content': text,
          'media_type': 'text',
        })
        .select()
        .maybeSingle();

    debugPrint('INSERT RESPONSE: $response');

    if (response == null) {
      throw Exception('Message insert failed (no row returned)');
    }
  }

  Future<Set<String>> _fetchHiddenMessageIds() async {
    final userId = currentUserId;
    if (userId == null) return {};

    final rows = await _supabase
        .from('hidden_messages')
        .select('message_id')
        .eq('user_id', userId);

    return rows.map<String>((r) => r['message_id'] as String).toSet();
  }

  Future<void> toggleReportMessage({
    required String messageId,
    required String reportedUserId,
    String? reason,
  }) async {
    final userId = currentUserId;
    if (userId == null) return;

    final existing = await _supabase
        .from('reports')
        .select('id')
        .eq('reporter_id', userId)
        .eq('reported_message_id', messageId)
        .filter('deleted_at', 'is', null)
        .maybeSingle();

    if (existing != null) {
      await _supabase.from('reports').delete().eq('id', existing['id']);
    } else {
      await _supabase.from('reports').insert({
        'reporter_id': userId,
        'reported_user_id': reportedUserId,
        'reported_message_id': messageId,
        'reason': reason,
        'status': 'pending',
      });
    }
  }

  Future<Set<String>> _fetchReportedMessageIds(List<String> messageIds) async {
    final userId = currentUserId;
    if (userId == null || messageIds.isEmpty) return {};

    final rows = await _supabase
        .from('reports')
        .select('reported_message_id')
        .eq('reporter_id', userId)
        .inFilter('reported_message_id', messageIds)
        .filter('deleted_at', 'is', null);

    return rows.map<String>((r) => r['reported_message_id'] as String).toSet();
  }

  Stream<List<ChatMessage>> streamMessages({required String roomId}) {
    final userId = currentUserId ?? '';

    return _supabase.from('messages').stream(primaryKey: ['id']).asyncMap((
      rows,
    ) async {
      final hiddenIds = await _fetchHiddenMessageIds();
      final filtered = rows
          .where(
            (row) =>
                row['live_chat_room_id'] == roomId &&
                row['deleted_at'] == null &&
                !hiddenIds.contains(row['id']),
          )
          .toList();

      final messageIds = filtered
          .map<String>((row) => row['id'] as String)
          .toList();

      final savedIds = await _fetchSavedMessageIds(messageIds);
      final reportedIds = await _fetchReportedMessageIds(messageIds);

      final serverMessages = filtered.map((row) {
        return ChatMessage.fromMap({
          ...row,
          'is_starred': savedIds.contains(row['id']),
          'is_reported': reportedIds.contains(row['id']),
        }, userId);
      }).toList();

      return serverMessages;
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

  Future<UserProfileData?> fetchUserProfile(String userId) async {
    final profileData = await _supabase
        .from('profiles')
        .select('full_name, avatar_url, location_id')
        .eq('id', userId)
        .maybeSingle();

    if (profileData == null) return null;

    String? locationName;

    if (profileData['location_id'] != null) {
      final locationData = await _supabase
          .from('locations')
          .select('name')
          .eq('id', profileData['location_id'])
          .maybeSingle();

      locationName = locationData?['name'];
    }

    return UserProfileData(
      fullName: profileData['full_name'],
      avatarUrl: profileData['avatar_url'],
      locationName: locationName,
    );
  }

  Future<void> toggleSaveMessage(String messageId) async {
    final userId = currentUserId;
    if (userId == null) return;

    final existing = await _supabase
        .from('saved_messages')
        .select('id')
        .eq('user_id', userId)
        .eq('message_id', messageId)
        .maybeSingle();

    if (existing != null) {
      await _supabase
          .from('saved_messages')
          .delete()
          .eq('user_id', userId)
          .eq('message_id', messageId);

      debugPrint('⭐ UNSTARRED message $messageId');
    } else {
      await _supabase.from('saved_messages').insert({
        'user_id': userId,
        'message_id': messageId,
        'saved_at': DateTime.now().toIso8601String(),
      });

      debugPrint('⭐ STARRED message $messageId');
    }
  }

  Future<void> forwardMessage({
    required String messageId,
    required String targetRoomId,
  }) async {
    final msg = await _supabase
        .from('messages')
        .select('content, media_type, media_url')
        .eq('id', messageId)
        .single();

    await _supabase.from('messages').insert({
      'live_chat_room_id': targetRoomId,
      'sender_id': _supabase.auth.currentUser!.id,
      'content': msg['content'],
      'media_type': msg['media_type'],
      'media_url': msg['media_url'],
    });
  }

  Future<Set<String>> _fetchSavedMessageIds(List<String> messageIds) async {
    final userId = currentUserId;
    if (userId == null || messageIds.isEmpty) return {};

    final rows = await _supabase
        .from('saved_messages')
        .select('message_id')
        .eq('user_id', userId)
        .inFilter('message_id', messageIds);

    return rows.map<String>((r) => r['message_id'] as String).toSet();
  }

  Future<void> deleteMessageForMe(String messageId) async {
    await _supabase.rpc(
      'delete_message_for_me',
      params: {'p_message_id': messageId},
    );
  }

  Future<void> deleteMessageForEveryone(String messageId) async {
    try {
      await _supabase.rpc(
        'delete_message_for_everyone',
        params: {'p_message_id': messageId},
      );
    } catch (e) {
      throw Exception('Failed to delete message: $e');
    }
  }
}
