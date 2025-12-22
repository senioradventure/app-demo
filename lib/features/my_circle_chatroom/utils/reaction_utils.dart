import 'package:senior_circle/features/my_circle_chatroom/models/message_model.dart';

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
