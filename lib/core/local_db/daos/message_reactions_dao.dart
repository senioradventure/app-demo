import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/message_reactions_table.dart';

part 'message_reactions_dao.g.dart';

@DriftAccessor(tables: [MessageReactions])
class MessageReactionsDao extends DatabaseAccessor<AppDatabase>
    with _$MessageReactionsDaoMixin {
  MessageReactionsDao(AppDatabase db) : super(db);

  /// Watch all reactions for a specific message
  Stream<List<MessageReaction>> watchReactionsByMessageId(String messageId) {
    return (select(
      messageReactions,
    )..where((t) => t.messageId.equals(messageId))).watch();
  }

  /// Insert a reaction, ignoring if it already exists (duplicate)
  Future<void> insertReaction(MessageReactionsCompanion reaction) {
    return into(
      messageReactions,
    ).insert(reaction, mode: InsertMode.insertOrIgnore);
  }

  /// Delete a specific reaction by message_id, user_id, and reaction
  Future<void> deleteReaction(
    String messageId,
    String userId,
    String reaction,
  ) {
    return (delete(messageReactions)..where(
          (t) =>
              t.messageId.equals(messageId) &
              t.userId.equals(userId) &
              t.reaction.equals(reaction),
        ))
        .go();
  }

  /// Delete all reactions for a specific message (useful for cleanup)
  Future<void> deleteReactionsByMessageId(String messageId) {
    return (delete(
      messageReactions,
    )..where((t) => t.messageId.equals(messageId))).go();
  }
}
