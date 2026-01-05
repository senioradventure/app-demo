class IndividualChatMessageModel {
  final String id;
  final String senderId;
  final String content;
  final String? mediaUrl;
  final String mediaType;
  final DateTime createdAt;
  final String? replyToMessageId;

  IndividualChatMessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    this.mediaUrl,
    required this.mediaType,
    required this.createdAt,
    this.replyToMessageId,
  });

  factory IndividualChatMessageModel.fromSupabase(Map<String, dynamic> json) {
    return IndividualChatMessageModel(
      id: json['id'],
      senderId: json['sender_id'],
      content: json['content'] ?? '',
      mediaUrl: json['media_url'],
      mediaType: json['media_type'],
      createdAt: DateTime.parse(json['created_at']),
      replyToMessageId: json['reply_to_message_id'],
    );
  }
}
