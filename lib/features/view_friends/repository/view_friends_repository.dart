import 'package:senior_circle/features/view_friends/models/friends_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewFriendsRepository {
  final SupabaseClient supabase;

  ViewFriendsRepository(this.supabase);

  Future<List<Friend>> getFriends(String userId) async {
    final response = await supabase.rpc(
      'get_friends',
      params: {'user_id': userId},
    );

    if (response == null) {
      return [];
    }

    final data = response as List;

    return data.map((e) => Friend.fromJson(e)).toList();
  }
}
