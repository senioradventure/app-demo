import 'package:senior_circle/features/my_circle_chatroom/models/reaction_model.dart';
import 'package:flutter/foundation.dart';

class GroupMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? avatar;
  final String? text;
  final String? imagePath;
  final String time;
  final List<Reaction> reactions;
  final List<GroupMessage> replies;
  final bool isThreadOpen;
  final bool isReplyInputOpen;
  final String? replyToMessageId;

  const GroupMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
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

  GroupMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? avatar,
    String? text,
    String? imagePath,
    String? time,
    List<Reaction>? reactions,
    List<GroupMessage>? replies,
    bool? isThreadOpen,
    bool? isReplyInputOpen,
    String? replyToMessageId,
    bool? isStarred,
  }) {
    return GroupMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
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

  factory GroupMessage.fromSupabase({
    required Map<String, dynamic> messageRow,
    required List<Reaction> reactions,
    List<GroupMessage> replies = const [],
    bool isStarred = false,
  }) {
    if (messageRow['sender_id'] == null) {
      debugPrint('⚠️ Message ${messageRow['id']} has NULL sender_id');
    }

    debugPrint(
      'GroupMessage.fromSupabase → id=${messageRow['id']} '
      'replyTo=${messageRow['reply_to_message_id']} '
      'reactions=${reactions.length}',
    );

    return GroupMessage(
      id: messageRow['id'] as String,
      senderId: messageRow['sender_id']?.toString() ?? '',
      senderName: messageRow['profiles']?['full_name'] ?? 'Unknown',
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

  factory GroupMessage.fromMap(Map<String, dynamic> map) {
    final reactionsRaw = Map<String, dynamic>.from(map['reactions'] ?? {});

    return GroupMessage(
      id: map['id'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      avatar: map['avatar'],
      text: map['text'],
      time: map['time'],
      imagePath: map['imagePath'],
      isThreadOpen: map['isThreadOpen'] ?? false,
      isReplyInputOpen: map['isReplyInputOpen'] ?? false,
      isStarred: map['isStarred'] ?? false,
      replies: (map['replies'] as List? ?? [])
          .map((e) => GroupMessage.fromMap(Map<String, dynamic>.from(e)))
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
  GroupMessage addReply(GroupMessage reply) {

    if (id == reply.replyToMessageId) {
      return copyWith(replies: [reply, ...replies]);
    }

    if (replies.isNotEmpty) {
      return copyWith(
        replies: replies.map((r) => r.addReply(reply)).toList(),
      );
    }

    return this;
  }

  GroupMessage toggleStar(String targetMessageId) {
    if (id == targetMessageId) {
      return copyWith(isStarred: !isStarred);
    }

    if (replies.isNotEmpty) {
      return copyWith(
        replies: replies.map((r) => r.toggleStar(targetMessageId)).toList(),
      );
    }

    return this;
  }

  GroupMessage updateReaction({
    required String messageId,
    required String emoji,
    required String userId,
    required GroupMessage Function({
      required GroupMessage message,
      required String targetMessageId,
      required String emoji,
      required String userId,
    }) applyReactionFn,
  }) {

    if (id == messageId) {
      return applyReactionFn(
        message: this,
        targetMessageId: messageId,
        emoji: emoji,
        userId: userId,
      );
    }

    if (replies.isNotEmpty) {
      return copyWith(
        replies: replies
            .map((r) => r.updateReaction(
                  messageId: messageId,
                  emoji: emoji,
                  userId: userId,
                  applyReactionFn: applyReactionFn,
                ))
            .toList(),
      );
    }

    return this;
  }
}
