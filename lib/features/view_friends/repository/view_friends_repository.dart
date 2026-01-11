import 'package:senior_circle/features/view_friends/models/friends_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewFriendsRepository {
  final SupabaseClient supabase;

  ViewFriendsRepository([SupabaseClient? client])
      : supabase = client ?? Supabase.instance.client;

  Future<List<Friend>> getFriends(String userId) async {
    final response = await supabase.rpc(
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
}
