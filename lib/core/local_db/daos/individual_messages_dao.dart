import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/individual_messages_table.dart';

part 'individual_messages_dao.g.dart';

@DriftAccessor(tables: [IndividualMessages])
class IndividualMessagesDao extends DatabaseAccessor<AppDatabase>
    with _$IndividualMessagesDaoMixin {
  IndividualMessagesDao(AppDatabase db) : super(db);

  /// WATCH messages for a single conversation
  Stream<List<IndividualMessage>> watchMessages(String conversationId) {
    return (select(individualMessages)
          ..where((t) => t.conversationId.equals(conversationId))
          ..where((t) => t.deletedAt.isNull())
          ..orderBy([
            (t) =>
                OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc),
          ]))
        .watch();
  }

  Future<void> upsertMessage(IndividualMessagesCompanion message) {
    return into(individualMessages).insertOnConflictUpdate(message);
  }

  Future<void> softDelete(String messageId) {
    return (update(
      individualMessages,
    )..where((t) => t.id.equals(messageId))).write(
      IndividualMessagesCompanion(deletedAt: Value(DateTime.now().toUtc())),
    );
  }

  Future<void> clearConversation(String conversationId) {
    return (delete(
      individualMessages,
    )..where((t) => t.conversationId.equals(conversationId))).go();
  }
}
