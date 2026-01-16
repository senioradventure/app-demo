import 'package:drift/drift.dart';

class Messages extends Table {
  /// Message ID (Supabase id or locally generated)
  TextColumn get id => text()();

  /// Chat room ID
  TextColumn get roomId => text()();

  /// Sender user ID
  TextColumn get senderId => text()();

  /// Message content (text only for now)
  TextColumn get content => text()();

  /// Whether message is synced with Supabase
  BoolColumn get isSynced =>
      boolean().withDefault(const Constant(true))();

  /// Created time
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
