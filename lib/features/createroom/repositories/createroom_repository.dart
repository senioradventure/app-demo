import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/createroom_preview_details_model.dart';

class CreateRoomRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final _uuid = const Uuid();

  /// Ensure profile exists (FIX for FK error)
  Future<void> _ensureProfileExists(String userId) async {
    final profile = await _client
        .from('profiles')
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    if (profile == null) {
      await _client.from('profiles').insert({'id': userId});
    }
  }

  /// Upload image → return public URL
  Future<String?> uploadRoomImage(File imageFile) async {
    final fileExt = imageFile.path.split('.').last;
    final fileName = 'live_chat_rooms/${_uuid.v4()}.$fileExt';

    await _client.storage.from('media').upload(
      fileName,
      imageFile,
      fileOptions: const FileOptions(upsert: false),
    );

    return _client.storage.from('media').getPublicUrl(fileName);
  }

  /// Create live chat room
  /// RETURNS: created room ID
  Future<String> createRoom({
    required CreateroomPreviewDetailsModel preview,
    required String adminId,
  }) async {
    // 🔥 Ensure FK safety
    await _ensureProfileExists(adminId);

    final imageUrl = await uploadRoomImage(preview.imageFile);

    final response = await _client
        .from('live_chat_rooms')
        .insert({
          'name': preview.name,
          'description': preview.description,
          'image_url': imageUrl,
          'admin_id': adminId,
          'location_id': preview.locationId, // ✅ from model
          'interests': preview.interests,
          'is_active': true,
        })
        .select('id')
        .single();

    return response['id'] as String;
  }
}
