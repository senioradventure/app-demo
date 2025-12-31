import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:senior_circle/features/createCircle/model/friend_model.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class CreateCircleRepository {
  final SupabaseClient _supabaseClient;
  final _uuid = const Uuid();

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

  Future<String?> uploadCircleImage(File imageFile) async {
    try {
      final fileExt = imageFile.path.split('.').last;
      final fileName = 'circles/${_uuid.v4()}.$fileExt';

      await _supabaseClient.storage
          .from('media')
          .upload(
            fileName,
            imageFile,
            fileOptions: const FileOptions(upsert: false),
          );

      return _supabaseClient.storage.from('media').getPublicUrl(fileName);
    } catch (e) {
      debugPrint('Error uploading image: $e');
      return null;
    }
  }

  Future<void> createCircle({
    required String name,
    required String adminId,
    File? imageFile,
    List<String> friendIds = const [],
  }) async {
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadCircleImage(imageFile);
      }

      final inviteCode = _uuid.v4();

      // 1. Create Circle
      final circleResponse = await _supabaseClient
          .from('circles')
          .insert({
            'name': name,
            'image_url': imageUrl,
            'admin_id': adminId,
            'invite_code': inviteCode,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select('id')
          .single();

      final String circleId = circleResponse['id'] as String;

      // 2. Add Admin as Member
      final List<Map<String, dynamic>> membersPayload = [
        {
          'circle_id': circleId,
          'user_id': adminId,
          'role': 'admin',
          'joined_at': DateTime.now().toIso8601String(),
        },
      ];

      // 3. Add Friends as Members
      for (final friendId in friendIds) {
        membersPayload.add({
          'circle_id': circleId,
          'user_id': friendId,
          'role': 'member',
          'joined_at': DateTime.now().toIso8601String(),
        });
      }

      await _supabaseClient.from('circle_members').insert(membersPayload);
    } catch (e) {
      debugPrint('Error creating circle: $e');
      throw Exception('Failed to create circle: $e');
    }
  }
}
