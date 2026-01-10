import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';

extension GroupMessageExtensions on GroupMessage {
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
