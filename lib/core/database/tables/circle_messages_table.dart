import 'package:drift/drift.dart';

class CircleMessages extends Table {
  TextColumn get id => text()();
  TextColumn get circleId => text()();
  TextColumn get senderId => text()();
  TextColumn get senderName => text()();
  TextColumn get mediaType => text().withDefault(const Constant('text'))();
  TextColumn get avatar => text().nullable()();
  TextColumn get content => text().nullable()();
  TextColumn get mediaUrl => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get replyToMessageId => text().nullable()();
  BoolColumn get isStarred => boolean().withDefault(const Constant(false))();
  
  // Store reactions and replies as JSON
  TextColumn get reactionsJson => text().withDefault(const Constant('{}'))();
  TextColumn get repliesJson => text().withDefault(const Constant('[]'))();
  
  @override
  Set<Column> get primaryKey => {id};
}
