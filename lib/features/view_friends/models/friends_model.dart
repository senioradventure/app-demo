class Friend {
  final String id;
  final String name;
  final String? profileImage;
  final bool isOnline;

  const Friend({
    required this.id,
    required this.name,
    this.profileImage,
    this.isOnline = false,
  });
}
