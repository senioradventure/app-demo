class UserProfile {
  final String id;
  final String name;
  final String? avatarUrl;
  final String? locationName;

  UserProfile({
    required this.id,
    required this.name,
    this.avatarUrl,
    this.locationName,
  });

  factory UserProfile.fromSupabase(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['full_name'] ?? '',
      avatarUrl: json['avatar_url'],
      locationName: json['locations']?['name'],
    );
  }
}
