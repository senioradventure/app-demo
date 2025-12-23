import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CircleRepository {
  final SupabaseClient _supabase;

  CircleRepository({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  Future<String?> uploadImage(File image) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String path = 'circle_images/$fileName';

      await _supabase.storage
          .from('media')
          .upload(
            path,
            image,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );
      final String imageUrl = _supabase.storage
          .from('media')
          .getPublicUrl(path);
      return imageUrl;
    } catch (e) {
      debugPrint('Error uploading image: $e');
      throw Exception('Error uploading image: $e');
    }
  }

  Future<String?> createCircleInDb(String name, String? imageUrl) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      final response = await _supabase.from('circles').insert({
        'name': name,
        'image_url': imageUrl,
        'admin_id': userId,
      }).select();

      if (response.isNotEmpty) {
        return response.first['id'] as String;
      }
      return null;
    } catch (e) {
      debugPrint('Error creating circle in DB: $e');
      rethrow;
    }
  }

  Future<void> addMembersToCircle(String circleId) async {
    try {
      final userId = _supabase.auth.currentUser?.id;

      final List<Map<String, dynamic>> membersToAdd = [
        {
          'circle_id': circleId,
          'user_id': userId,
          'role': 'admin',
          'joined_at': DateTime.now().toIso8601String(),
        },
      ];

      await _supabase.from('circle_members').insert(membersToAdd);
    } catch (e) {
      debugPrint('Error adding members: $e');
      rethrow;
    }
  }
}
