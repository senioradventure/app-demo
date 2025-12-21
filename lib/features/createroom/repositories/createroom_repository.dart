import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/createroom_preview_details_model.dart';

class CreateRoomRepository {
  final SupabaseClient _client = Supabase.instance.client;
  final _uuid = const Uuid();

  CreateRoomRepository() {
    final user = _client.auth.currentUser;
    debugPrint("Current user: ${user?.id}");
  }

  /// Upload image → return public URL
  Future<String?> uploadRoomImage(File? imageFile) async {
    if (imageFile == null) return null;

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
  Future<void> createRoom({
    required CreateroomPreviewDetailsModel preview,
    required String adminId,
    String? locationId,
  }) async {
    final imageUrl = await uploadRoomImage(preview.imageFile);

    final response = await _client.from('live_chat_rooms').insert({
      'name': preview.name,
      'description': preview.description,
      'image_url': imageUrl,
      'admin_id': adminId,
      'location_id': locationId,
      'interests': preview.interests, // ✅ text[]
      'is_active': true,
    });

    if (response.error != null) {
      throw response.error!;
    }
  }
}
