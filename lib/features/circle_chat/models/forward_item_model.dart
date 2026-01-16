class ForwardItem {
  final String id;
  final String name;
  final String? avatarUrl;
  final bool isGroup;
  final String? otherUserId;

  ForwardItem({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.isGroup,
    this.otherUserId,
  });
}