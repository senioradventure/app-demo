import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:senior_circle/core/enum/profile_visibility.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  final SupabaseClient supabase;

  ProfileRepository(this.supabase);


  Future<Profile> fetchProfile(String userId) async {
  final data = await supabase
      .from('profiles')
      .select('''
        id,
        full_name,
        username,
        avatar_url,
        user_settings (
          user_id,
          friend_request_privacy
        )
      ''')
      .eq('id', userId)
      .maybeSingle();

  if (data == null) {
    throw Exception('Profile not found');
  }

  return Profile.fromJson(data);
}


  Future<Profile> updateProfile({
    required String userId,
    String? fullName,
    String? locationId,
    XFile? imageFile,
  }) async {
    String? avatarUrl;

    if (imageFile != null) {
  final ext = extension(imageFile.path);
  final fileName = '${DateTime.now().millisecondsSinceEpoch}$ext';
  final path = 'profiles/$userId/$fileName';

  await supabase.storage.from('media').upload(
        path,
        File(imageFile.path),
        fileOptions: const FileOptions(upsert: true),
      );

  avatarUrl = supabase.storage.from('media').getPublicUrl(path);
}


    final updateData = <String, dynamic>{};

    if (fullName != null) {
      updateData['full_name'] = fullName;
    }

    if (locationId != null && locationId.isNotEmpty) {
      updateData['location_id'] = locationId; 
    }

    if (avatarUrl != null) {
      updateData['avatar_url'] = avatarUrl;
    }

    final data = await supabase
        .from('profiles')
        .update(updateData)
        .eq('id', userId)
        .select()
        .single();

    return Profile.fromJson(data);
  }

Future<void> updateVisibility({
  required String userId,
  required ProfileVisibility visibility,
}) async {
  final res = await supabase
      .from('user_settings')
      .update({
        'friend_request_privacy': visibility.supabaseValue,
      })
      .eq('user_id', userId);

  debugPrint('🟢 [Repo] UPDATE result: $res');
}



}
