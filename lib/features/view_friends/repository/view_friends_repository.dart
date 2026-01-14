import 'package:senior_circle/core/client/supabase_client.dart';
import 'package:senior_circle/features/my_circle_home/models/my_circle_model.dart';
import 'package:senior_circle/features/view_friends/models/friends_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewFriendsRepository {
  final SupabaseClient _client;

  ViewFriendsRepository([SupabaseClient? client])
      : _client = client ?? Supabase.instance.client;

  Future<List<Friend>> getFriends(String userId) async {
    final response = await _client.rpc(
      'get_friends',
      params: {'user_id': userId},
    );

    if (response == null) {
      return [];
    }

    final data = response as List;
    final Map<String, Friend> friends = {};

    for (var e in data) {
      final friend = Friend.fromJson(e);
      friends[friend.id] = friend;
    }

    return friends.values.toList();
  }

  String? get currentUserId => supabase.auth.currentUser?.id;

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

  Future<String> getCurrentUserId() async {
    return _client.auth.currentUser!.id;
  }
  
}
