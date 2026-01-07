import 'package:senior_circle/core/client/supabase_client.dart';
import 'package:senior_circle/features/starred_messages/data/models/saved_message_model.dart';

class StarredMessagesRepository {
  Future<List<SavedMessage>> fetchStarredMessages() async {
    try {
      final response = await supabase
          .from('saved_messages')
          .select()
          .order(
            'id',
            ascending: false,
          ); // Order by some criteria, assuming id or created_at if available. Using id for now.

      return (response as List<dynamic>)
          .map((e) => SavedMessage.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch starred messages: $e');
    }
  }
}
