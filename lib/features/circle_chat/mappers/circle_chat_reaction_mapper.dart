import '../models/reaction_model.dart';

class CircleChatReactionMapper {
  static List<Reaction> aggregate(List<Map<String, dynamic>> rows) {
    final Map<String, List<String>> grouped = {};

    for (final row in rows) {
      final emoji = row['reaction'] as String;
      final userId = row['user_id'] as String;

      grouped.putIfAbsent(emoji, () => []);
      grouped[emoji]!.add(userId);
    }

    return grouped.entries
        .map(
          (e) => Reaction(
            emoji: e.key,
            userIds: e.value,
          ),
        )
        .toList();
  }
}
