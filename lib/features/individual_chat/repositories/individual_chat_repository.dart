import 'package:senior_circle/features/individual_chat/model/individual_chat_message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IndividualChatRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<IndividualChatMessageModel>> loadMessages(
    String conversationId,
  ) async {
    final response = await _client
        .from('messages')
        .select('*, message_reactions(*)')
        .eq('conversation_id', conversationId)
        .filter('deleted_at', 'is', null)
        .or('expires_at.is.null,expires_at.gt.${DateTime.now().toUtc()}')
        .order('created_at', ascending: true);

    return (response as List)
        .map((e) => IndividualChatMessageModel.fromSupabase(e))
        .toList();
  }

  Future<void> sendMessage({
    required String conversationId,
    required String text,
    String? imagePath,
  }) async {
    await _client.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': _client.auth.currentUser!.id,
      'content': text,
      'media_url': imagePath,
      'media_type': imagePath == null ? 'text' : 'image',
    });
  }

  Future<void> addReaction({
    required String messageId,
    required String reaction,
  }) async {
    final userId = _client.auth.currentUser!.id;

    final existingResponse = await _client
        .from('message_reactions')
        .select()
        .eq('message_id', messageId)
        .eq('user_id', userId);

    final existing = (existingResponse as List);

    if (existing.isNotEmpty) {
      await _client
          .from('message_reactions')
          .delete()
          .eq('id', existing.first['id']);

      if (existing.first['reaction'] == reaction) {
        return; // toggle off
      }
    }

    await _client.from('message_reactions').insert({
      'message_id': messageId,
      'user_id': userId,
      'reaction': reaction,
    });
  }
}
