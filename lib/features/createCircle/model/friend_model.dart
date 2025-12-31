class Friend {
  final String id;
  final String? avatarUrl;
  final String fullName;
  final String username;

  Friend({
    required this.id,
    this.avatarUrl,
    required this.fullName,
    required this.username,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] as String,
      avatarUrl: json['avatar_url'] as String?,
      fullName: json['full_name'] as String? ?? 'Unknown',
      username: json['username'] as String? ?? 'Unknown',
    );
  }
}
