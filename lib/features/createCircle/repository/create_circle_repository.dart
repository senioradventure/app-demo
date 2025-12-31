import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:senior_circle/features/createCircle/model/friend_model.dart';
import 'package:flutter/foundation.dart';

class CreateCircleRepository {
  final SupabaseClient _supabaseClient;

  CreateCircleRepository({SupabaseClient? supabaseClient})
    : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  Future<List<Friend>> fetchFriends(String userId) async {
    try {
      final data = await _supabaseClient.rpc(
        'get_friends',
        params: {'user_id': userId},
      );

      final List<dynamic> responseList = data as List<dynamic>;
      return responseList.map((json) => Friend.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching friends: $e');
      throw Exception('Failed to fetch friends');
    }
  }
}
