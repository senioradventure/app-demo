class Chat {
  final String name;
  final String lastMessage;
  final String imageUrl;
  final bool isGroup;
  final String time;
  final int unreadCount;

  Chat({
    required this.name,
    required this.lastMessage,
    required this.imageUrl,
    required this.isGroup,
    required this.time,
    this.unreadCount = 0,
  });
}