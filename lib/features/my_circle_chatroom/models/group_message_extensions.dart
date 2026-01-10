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

  /// Generic recursive updater for a message tree.
  GroupMessage updateRecursive(
    String targetId,
    GroupMessage Function(GroupMessage) updateFn, {
    bool clearOthers = false,
  }) {
    GroupMessage updated = this;

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

  /// Recursively find a message by ID.
  GroupMessage? findRecursive(String targetId) {
    if (id == targetId) return this;
    for (final reply in replies) {
      final found = reply.findRecursive(targetId);
      if (found != null) return found;
    }
    return null;
  }

  /// Recursively remove a message by ID.
  /// Note: Returns null if this message itself is the target to be removed.
  GroupMessage? removeRecursive(String targetId) {
    if (id == targetId) return null;
    if (replies.isEmpty) return this;

    return copyWith(
      replies: replies
          .map((r) => r.removeRecursive(targetId))
          .whereType<GroupMessage>()
          .toList(),
    );
  }
}
