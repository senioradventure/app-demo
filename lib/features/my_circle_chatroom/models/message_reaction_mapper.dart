import 'message_model.dart';
import 'reaction_model.dart';

extension MessageReactionMapper on Message {
  List<Reaction> get reactionList {
    return reactions.entries.map((entry) {
      return Reaction(
        emoji: entry.key, 
        userIds: entry.value,
      );
    }).toList();
  }
}
