import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/my_circle_model.dart';

class MyCircleRepository {
  final _client = Supabase.instance.client;

  Future<List<MyCircle>> fetchMyCircleChats() async {
    final userId = _client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // 🔹 Individual chats (RPC)
    final individualResponse = await _client.rpc(
      'get_all_conversations',
      params: {'p_user_id': userId},
    );
    debugPrint('🟩 [MyCircleRepo] Individual chats count: ${(individualResponse as List?)?.length}');
    // debugPrint('🟩 [MyCircleRepo] First individual chat sample: ${individualResponse.first}');

    // 🔹 Circle / group chats (filtered by membership)
    final circleResponse = await _client
        .from('circles')
        .select('*, circle_members!inner(user_id)')
        .eq('circle_members.user_id', userId)
        .filter('deleted_at', 'is', null)
        .order('updated_at', ascending: false);
    debugPrint('🟩 [MyCircleRepo] Circle chats count: ${(circleResponse as List?)?.length}');

    final individualChats = (individualResponse  ?? [])
        .map(
          (json) =>
              MyCircle.fromConversationRpc(json as Map<String, dynamic>),
        )
        .toList();

    final circleChats = (circleResponse as List? ?? [])
        .map((json) => MyCircle.fromSupabase(json as Map<String, dynamic>))
        .toList();

    final allChats = [...individualChats, ...circleChats]
      ..sort((a, b) {
        final aTime = a.updatedAt ?? a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.updatedAt ?? b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });

    return allChats;
  }

  String? get currentUserId => _client.auth.currentUser?.id;

  RealtimeChannel subscribeToMessageUpdates(void Function() onUpdate) {
    debugPrint('🟦 [MyCircleRepo] Initializing real-time subscription');
    return _client
        .channel('my_circle_messages_refresh')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            debugPrint('🟨 [MyCircleRepo] New message detected, refreshing list...');
            onUpdate();
          },
        )
        .subscribe();
  }
}
