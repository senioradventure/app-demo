import 'package:senior_circle/features/my_circle_home/models/my_circle_model.dart';
import 'package:senior_circle/features/view_friends/models/friends_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewFriendsRepository {
  final SupabaseClient _client;

  ViewFriendsRepository(this._client);

  Future<List<Friend>> getFriends(String userId) async {
    final response = await _client.rpc(
      'get_friends',
      params: {'user_id': userId},
    );

    if (response == null) {
      return [];
    }

    final data = response as List;

    return data.map((e) => Friend.fromJson(e)).toList();
  }

  Future<MyCircle> getOrCreateIndividualChatWithFriend(String friendId) async {
    final userId = _client.auth.currentUser!.id;
    final response = await _client.rpc(
      'get_all_conversations',
      params: {'p_user_id': userId},
    );

    final List conversations = response as List;

    final matchingConversation = conversations.firstWhere(
      (c) => c['other_user']?['id'] == friendId,
      orElse: () => null,
    );
    if (matchingConversation != null) {
      return MyCircle.fromConversationRpc(
        matchingConversation as Map<String, dynamic>,
      );
    }
    final createResponse = await _client.rpc(
      'create_conversation',
      params: {'p_other_user_id': friendId},
    );
    final refreshedResponse = await _client.rpc(
      'get_all_conversations',
      params: {'p_user_id': userId},
    );

    final List refreshedConversations = refreshedResponse as List;

    final newConversation = refreshedConversations.firstWhere(
      (c) => c['other_user']?['id'] == friendId,
      orElse: () => throw Exception('Conversation creation failed'),
    );
    return MyCircle.fromConversationRpc(
      newConversation as Map<String, dynamic>,
    );
  }
  
}
