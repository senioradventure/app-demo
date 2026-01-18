import 'package:senior_circle/features/individual_chat/model/individual_message_reaction_model.dart';

class IndividualChatMessageModel {
  final String id;
  final String senderId;
  final String? receiverId;
  final String content;
  final String? mediaUrl;
  final String? localMediaPath;
  final String mediaType;
  final DateTime createdAt;
  final String? replyToMessageId;

  /// 🔥 ADD THIS
  final List<MessageReaction> reactions;

  IndividualChatMessageModel({
    required this.id,
    required this.senderId,
    this.receiverId,
    required this.content,
    this.mediaUrl,
    this.localMediaPath,
    required this.mediaType,
    required this.createdAt,
    this.replyToMessageId,
    this.reactions = const [],
  });

  factory IndividualChatMessageModel.fromSupabase(Map<String, dynamic> json) {
    return IndividualChatMessageModel(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'], // 👈 added
      content: json['content'] ?? '',
      mediaUrl: json['media_url'],
      mediaType: json['media_type'],
      createdAt: DateTime.parse(json['created_at']),
      replyToMessageId: json['reply_to_message_id'],
      reactions: (json['message_reactions'] as List? ?? [])
          .map((e) => MessageReaction.fromSupabase(e))
          .toList(),
    );
  }

  IndividualChatMessageModel copyWith({
    List<MessageReaction>? reactions,
    String? receiverId,
    String? localMediaPath,
  }) {
    return IndividualChatMessageModel(
      id: id,
      senderId: senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content,
      mediaUrl: mediaUrl,
      localMediaPath: localMediaPath ?? this.localMediaPath,
      mediaType: mediaType,
      createdAt: createdAt,
      replyToMessageId: replyToMessageId,
      reactions: reactions ?? this.reactions,
    );
  }
}
