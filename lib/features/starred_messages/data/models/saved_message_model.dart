class SavedMessage {
  final String id;
  final String userId;
  final String messageId;
  final String senderId;
  final String? content;
  final String? mediaUrl;
  final String mediaType;

  SavedMessage({
    required this.id,
    required this.userId,
    required this.messageId,
    required this.senderId,
    this.content,
    this.mediaUrl,
    required this.mediaType,
  });

  factory SavedMessage.fromJson(Map<String, dynamic> json) {
    return SavedMessage(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      messageId: json['message_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String?,
      mediaUrl: json['media_url'] as String?,
      mediaType: json['media_type'] as String,
    );
  }
}
