import 'package:drift/drift.dart';

class IndividualMessages extends Table {
  TextColumn get id => text()();
  TextColumn get senderId => text()();
  TextColumn get content => text()();
  TextColumn get mediaUrl => text().nullable()();
  TextColumn get mediaType => text()();
  TextColumn get localMediaPath => text().nullable()();
  TextColumn get conversationId => text()();
  TextColumn get replyToMessageId => text().nullable()();
  TextColumn get forwardedFromMessageId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
