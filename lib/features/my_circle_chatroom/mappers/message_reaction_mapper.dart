import '../models/message_model.dart';
import '../models/reaction_model.dart';

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
