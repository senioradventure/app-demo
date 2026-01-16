// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'circle_messages_dao.dart';

// ignore_for_file: type=lint
mixin _$CircleMessagesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CircleMessagesTable get circleMessages => attachedDatabase.circleMessages;
  CircleMessagesDaoManager get managers => CircleMessagesDaoManager(this);
}

class CircleMessagesDaoManager {
  final _$CircleMessagesDaoMixin _db;
  CircleMessagesDaoManager(this._db);
  $$CircleMessagesTableTableManager get circleMessages =>
      $$CircleMessagesTableTableManager(
        _db.attachedDatabase,
        _db.circleMessages,
      );
}
