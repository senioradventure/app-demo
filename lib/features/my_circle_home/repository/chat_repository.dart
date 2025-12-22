import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/circle_chat_model.dart';

class ChatRepository {
  final _client = Supabase.instance.client;

  Future<List<CircleChat>> fetchChats() async {
    final data = await _client
        .from('circles')
        .select()
        .filter('deleted_at', 'is', null)
        .order('updated_at', ascending: false);

    return (data as List)
        .map((json) => CircleChat.fromSupabase(json))
        .toList();
  }
}
