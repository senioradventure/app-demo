class MessageReaction {
  final String id;
  final String userId;
  final String reaction;

  MessageReaction({
    required this.id,
    required this.userId,
    required this.reaction,
  });

  factory MessageReaction.fromSupabase(Map<String, dynamic> json) {
    return MessageReaction(
      id: json['id'],
      userId: json['user_id'],
      reaction: json['reaction'],
    );
  }
}
