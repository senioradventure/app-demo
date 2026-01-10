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

    // 🔹 Circle / group chats (filtered by membership)
    final circleResponse = await _client
        .from('circles')
        .select('*, circle_members!inner(user_id)')
        .eq('circle_members.user_id', userId)
        .filter('deleted_at', 'is', null)
        .order('updated_at', ascending: false);

    final individualChats = (individualResponse as List? ?? [])
        .map(
          (json) =>
              MyCircle.fromConversationRpc(json as Map<String, dynamic>),
        )
        .toList();

    final circleChats = (circleResponse as List? ?? [])
        .map((json) => MyCircle.fromSupabase(json as Map<String, dynamic>))
        .toList();

    final allChats = [...individualChats, ...circleChats]
      ..sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

    return allChats;
  }
}
