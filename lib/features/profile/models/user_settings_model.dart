import 'package:senior_circle/core/enum/profile_visibility.dart';

class UserSettings {
  final String userId;
  final ProfileVisibility visibility;

  const UserSettings({
    required this.userId,
    required this.visibility,
  });

factory UserSettings.defaultFor(String userId) {
    return UserSettings(
      userId: userId,
      visibility: ProfileVisibility.everyone, 
    );
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['user_id'] as String,
    
      visibility: profileVisibilityFromDb(
        json['friend_request_privacy'] as String?,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'friend_request_privacy': visibility.supabaseValue,
    };
  }

  UserSettings copyWith({
    ProfileVisibility? visibility,
  }) {
    return UserSettings(
      userId: userId,
      visibility: visibility ?? this.visibility,
    );
  }
}
