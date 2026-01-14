import 'package:senior_circle/features/circle_chat/models/circle_chat_message_model.dart';
import 'package:senior_circle/features/circle_chat/models/message_model.dart';
import 'package:senior_circle/features/circle_chat/models/reaction_model.dart';

Message toggleReaction({
  required Message message,
  required String emoji,
  required String userId,
}) {
  final newReactions = <String, List<String>>{};

  message.reactions.forEach((key, value) {
    newReactions[key] = List<String>.from(value);
  });

  String? existingEmoji;
  newReactions.forEach((key, users) {
    if (users.contains(userId)) {
      existingEmoji = key;
    }
  });

  if (existingEmoji != null) {
    newReactions[existingEmoji!]!.remove(userId);

    if (newReactions[existingEmoji!]!.isEmpty) {
      newReactions.remove(existingEmoji);
    }
  }

  if (existingEmoji == emoji) {
    return message.copyWith(reactions: newReactions);
  }

  newReactions.putIfAbsent(emoji, () => []);
  newReactions[emoji]!.add(userId);

  return message.copyWith(reactions: newReactions);
}

CircleChatMessage applyReaction({
  required CircleChatMessage message,
  required String targetMessageId,
  required String emoji,
  required String userId,
}) {
  if (message.id != targetMessageId) return message;

  final reactions = [...message.reactions];

  final index = reactions.indexWhere((r) => r.emoji == emoji);

  if (index != -1) {
    final reaction = reactions[index];
    final updatedUserIds = [...reaction.userIds];

    if (updatedUserIds.contains(userId)) {
      updatedUserIds.remove(userId);
    } else {
      updatedUserIds.add(userId);
    }

    if (updatedUserIds.isEmpty) {
      reactions.removeAt(index);
    } else {
      reactions[index] =
          reaction.copyWith(userIds: updatedUserIds);
    }
  } else {
    reactions.add(
      Reaction(
        emoji: emoji,
        userIds: [userId],
      ),
    );
  }

  return message.copyWith(reactions: reactions);
}
