import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> sendOtp(String phoneNumber) async {
    await _client.auth.signInWithOtp(phone: phoneNumber);
  }

  Future<AuthResponse> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    return await _client.auth.verifyOTP(
      phone: phoneNumber,
      token: otp,
      type: OtpType.sms,
    );
  }

  bool hasActiveSession() {
    return _client.auth.currentSession != null;
  }

  /// 🔹 Upload profile image and return public URL
  Future<String?> uploadProfileImage({
    required File file,
    required String userId,
  }) async {
    final path = 'profiles/$userId.jpg';

    await _client.storage
        .from('media')
        .upload(
          path,
          file,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

    return _client.storage.from('media').getPublicUrl(path);
  }

  /// 🔹 Insert profile data
  Future<void> createProfile({
    required String userId,
    required String phoneNumber,
    required String fullName,
    required String? avatarUrl,
    required String? locationId,
  }) async {
    await _client.from('profiles').insert({
      'id': userId,
      'username': phoneNumber, // ✅ phone as username
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'location_id': locationId,
    });
  }
}
