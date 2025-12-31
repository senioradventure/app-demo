import 'package:senior_circle/features/profile/models/user_settings_model.dart';

class Profile {
  final String id;
  final String? username;
  final String? fullName;
  final String? avatarUrl;
  final String? role;
  final String? locationId;
  final UserSettings? settings;

  Profile({
    required this.id,
    this.username,
    this.fullName,
    this.avatarUrl,
    this.role,
    this.locationId,
    this.settings,
  });

  factory Profile.fromJson(Map<dynamic, dynamic> json) {
    final settingsJson = json['user_settings'];

    UserSettings settings;

    if (settingsJson is List && settingsJson.isNotEmpty) {
      settings = UserSettings.fromJson(settingsJson.first);
    } else if (settingsJson is Map<String, dynamic>) {
      settings = UserSettings.fromJson(settingsJson);
    } else {
      settings = UserSettings.defaultFor(json['id']);
    }

    return Profile(
      id: json['id'] as String,
      username: json['username'] as String?,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: json['role'] as String?,
      locationId: json['location_id'] as String?,
      settings: json['user_settings'] == null
          ? UserSettings.defaultFor(json['id'])
          : UserSettings.fromJson(json['user_settings']),
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'username': username,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'role': role,
      'location_id': locationId,
      'settings': settings,
    };
  }

  Profile copyWith({
    String? username,
    String? fullName,
    String? avatarUrl,
    String? role,
    String? locationId,
    UserSettings? settings,
  }) {
    return Profile(
      id: id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      locationId: locationId ?? this.locationId,
      settings: settings ?? this.settings,
    );
  }
}
