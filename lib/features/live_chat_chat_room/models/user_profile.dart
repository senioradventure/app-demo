class ChatUserProfile {
  final String id;
  final String username;
  final String? fullName;
  final String? avatarUrl;
  final String? locationName;

  ChatUserProfile({
    required this.id,
    required this.username,
    this.fullName,
    this.avatarUrl,
    this.locationName,
  });
}