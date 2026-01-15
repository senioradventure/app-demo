import 'package:drift/drift.dart';

class MessageReactions extends Table {
  TextColumn get id => text()();
  TextColumn get messageId => text()();
  TextColumn get userId => text()();
  TextColumn get reaction => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {messageId, userId, reaction},
  ];
}
