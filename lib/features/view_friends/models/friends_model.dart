class Friend {
  final String id;
  final String name;
  final String? profileImage;
  final bool? isOnline;

  const Friend({
    required this.id,
    required this.name,
    this.profileImage,
    this.isOnline = false,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      name: json['full_name'],
      profileImage: json['avatar_url'] ?? '',
      isOnline: json['is_online'] ?? false,
    );
  }
}
