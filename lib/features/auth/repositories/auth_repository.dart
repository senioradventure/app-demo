import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // ================= OTP =================

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

  /// 🔹 Check if there is an active session AND user profile exists
  Future<bool> hasActivated() async {
    final session = _client.auth.currentSession;

    // No session → false
    if (session == null) {
      return false;
    }

    final userId = session.user.id;

    // Check if profile exists for this user
    final bool userExists = await doesUserProfileExist(userId);

    return userExists;
  }

  // ================= PROFILE CHECK =================

  /// 🔹 Check if user profile already exists
  Future<bool> doesUserProfileExist(String userId) async {
    final response = await _client
        .from('profiles')
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    return response != null;
  }

  // ================= IMAGE UPLOAD =================

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

  // ================= CREATE PROFILE =================

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
  // ================= LOGOUT =================

  /// 🔹 Logout user and clear session
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
