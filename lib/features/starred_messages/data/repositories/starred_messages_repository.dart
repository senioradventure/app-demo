import 'package:senior_circle/core/client/supabase_client.dart';
import 'package:senior_circle/features/starred_messages/data/models/saved_message_model.dart';

class StarredMessagesRepository {
  Future<List<SavedMessage>> fetchStarredMessages() async {
    try {
      final response = await supabase
          .from('saved_messages')
          .select('''
            *,
            profiles:sender_id (full_name)
          ''')
          .order('id', ascending: false);

      return (response as List<dynamic>)
          .map((e) => SavedMessage.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch starred messages: $e');
    }
  }
}
