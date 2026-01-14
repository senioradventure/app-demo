import 'package:senior_circle/features/circle_chat/models/reaction_model.dart';
import 'package:flutter/foundation.dart';

class CircleChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? avatar;
  final String mediaType;
  final String? text;
  final String? imagePath;
  final String time;
  final List<Reaction> reactions;
  final List<CircleChatMessage> replies;
  final bool isThreadOpen;
  final bool isReplyInputOpen;
  final String? replyToMessageId;

  const CircleChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.mediaType,
    this.avatar,
    this.text,
    required this.time,
    this.imagePath,
    this.reactions = const [],
    this.replies = const [],
    this.isThreadOpen = false,
    this.isReplyInputOpen = false,
    this.replyToMessageId,
    this.isStarred = false,
  });

  final bool isStarred;

  CircleChatMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? mediaType,
    String? avatar,
    String? text,
    String? imagePath,
    String? time,
    List<Reaction>? reactions,
    List<CircleChatMessage>? replies,
    bool? isThreadOpen,
    bool? isReplyInputOpen,
    String? replyToMessageId,
    bool? isStarred,
  }) {
    return CircleChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      mediaType: mediaType ?? this.mediaType,
      avatar: avatar ?? this.avatar,
      text: text ?? this.text,
      imagePath: imagePath ?? this.imagePath,
      time: time ?? this.time,
      reactions: reactions ?? this.reactions,
      replies: replies ?? this.replies,
      isThreadOpen: isThreadOpen ?? this.isThreadOpen,
      isReplyInputOpen: isReplyInputOpen ?? this.isReplyInputOpen,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      isStarred: isStarred ?? this.isStarred,
    );
  }

  factory CircleChatMessage.fromSupabase({
    required Map<String, dynamic> messageRow,
    required List<Reaction> reactions,
    List<CircleChatMessage> replies = const [],
    bool isStarred = false,
  }) {
    if (messageRow['sender_id'] == null) {
      debugPrint('Message ${messageRow['id']} has NULL sender_id');
    }

    debugPrint(
      'GroupMessage.fromSupabase → id=${messageRow['id']} '
      'replyTo=${messageRow['reply_to_message_id']} '
      'reactions=${reactions.length}',
    );

    return CircleChatMessage(
      id: messageRow['id'] as String,
      senderId: messageRow['sender_id']?.toString() ?? '',
      senderName: messageRow['profiles']?['full_name'] ?? 'Unknown',
      mediaType: messageRow['media_type']?? 'text',
      avatar: messageRow['profiles']?['avatar_url'],
      text: messageRow['content'],
      imagePath: messageRow['media_type'] == 'image'
          ? messageRow['media_url']
          : null,
      time: messageRow['created_at']?.toString() ?? '',
      reactions: reactions,
      replies: replies,
      replyToMessageId: messageRow['reply_to_message_id'],
      isStarred: isStarred,
    );
  }

  factory CircleChatMessage.fromMap(Map<String, dynamic> map) {
    final reactionsRaw = Map<String, dynamic>.from(map['reactions'] ?? {});

    return CircleChatMessage(
      id: map['id'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      mediaType: map['mediaType'] ?? 'text',
      avatar: map['avatar'],
      text: map['text'],
      time: map['time'],
      imagePath: map['imagePath'],
      isThreadOpen: map['isThreadOpen'] ?? false,
      isReplyInputOpen: map['isReplyInputOpen'] ?? false,
      isStarred: map['isStarred'] ?? false,
      replies: (map['replies'] as List? ?? [])
          .map((e) => CircleChatMessage.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      reactions: reactionsRaw.entries.map((entry) {
        return Reaction(
          emoji: entry.key,
          userIds: List<String>.from(entry.value),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'mediaType': mediaType,
      'avatar': avatar,
      'text': text,
      'imagePath': imagePath,
      'time': time,
      'isThreadOpen': isThreadOpen,
      'isReplyInputOpen': isReplyInputOpen,
      'reactions': {
        for (final reaction in reactions) reaction.emoji: reaction.userIds,
      },
      'replies': replies.map((reply) => reply.toMap()).toList(),
      'isStarred': isStarred,
    };
  }
}
