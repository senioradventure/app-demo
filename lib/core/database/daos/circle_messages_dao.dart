import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/circle_messages_table.dart';

part 'circle_messages_dao.g.dart';

@DriftAccessor(tables: [CircleMessages])
class CircleMessagesDao extends DatabaseAccessor<AppDatabase> with _$CircleMessagesDaoMixin {
  CircleMessagesDao(AppDatabase db) : super(db);

  /// Get all messages for a circle
  Future<List<CircleMessage>> getMessagesByCircle(String circleId) {
    return (select(circleMessages)
          ..where((tbl) => tbl.circleId.equals(circleId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  /// Get message by ID
  Future<CircleMessage?> getMessageById(String id) {
    return (select(circleMessages)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// Insert or update message
  Future<void> upsertMessage(CircleMessagesCompanion message) {
    return into(circleMessages).insertOnConflictUpdate(message);
  }

  /// Bulk upsert messages
  Future<void> upsertMessages(List<CircleMessagesCompanion> messageList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(circleMessages, messageList);
    });
  }

  /// Delete message
  Future<void> deleteMessage(String id) {
    return (delete(circleMessages)..where((tbl) => tbl.id.equals(id))).go();
  }

  /// Clear all messages for a circle
  Future<void> clearCircleMessages(String circleId) {
    return (delete(circleMessages)..where((tbl) => tbl.circleId.equals(circleId))).go();
  }

  /// Update message starred status
  Future<void> updateStarredStatus(String id, bool isStarred) {
    return (update(circleMessages)..where((tbl) => tbl.id.equals(id)))
        .write(CircleMessagesCompanion(isStarred: Value(isStarred)));
  }
}
