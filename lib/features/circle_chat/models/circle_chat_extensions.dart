import 'package:senior_circle/features/circle_chat/models/circle_chat_message_model.dart';

extension CircleChatExtensions on CircleChatMessage {
  CircleChatMessage addReply(CircleChatMessage reply) {
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

  CircleChatMessage toggleStar(String targetMessageId) {
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

  
  CircleChatMessage updateReaction({
    required String messageId,
    required String emoji,
    required String userId,
    required CircleChatMessage Function({
      required CircleChatMessage message,
      required String targetMessageId,
      required String emoji,
      required String userId,
    }) applyReactionFn,
  }) {
    return updateRecursive(
      messageId,
      (msg) => applyReactionFn(
        message: msg,
        targetMessageId: messageId,
        emoji: emoji,
        userId: userId,
      ),
    );
  }

  CircleChatMessage updateRecursive(
    String targetId,
    CircleChatMessage Function(CircleChatMessage) updateFn, {
    bool clearOthers = false,
  }) {
    CircleChatMessage updated = this;

    if (id == targetId) {
      updated = updateFn(updated);
    } else if (clearOthers) {
      updated = updated.copyWith(
        isThreadOpen: false,
        isReplyInputOpen: false,
      );
    }

    if (updated.replies.isNotEmpty) {
      updated = updated.copyWith(
        replies: updated.replies
            .map((r) => r.updateRecursive(targetId, updateFn, clearOthers: clearOthers))
            .toList(),
      );
    }

    return updated;
  }

  CircleChatMessage? findRecursive(String targetId) {
    if (id == targetId) return this;
    for (final reply in replies) {
      final found = reply.findRecursive(targetId);
      if (found != null) return found;
    }
    return null;
  }

  CircleChatMessage? removeRecursive(String targetId) {
    if (id == targetId) return null;
    if (replies.isEmpty) return this;

    return copyWith(
      replies: replies
          .map((r) => r.removeRecursive(targetId))
          .whereType<CircleChatMessage>()
          .toList(),
    );
  }
}
