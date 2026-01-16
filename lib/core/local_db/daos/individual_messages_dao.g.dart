// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'individual_messages_dao.dart';

// ignore_for_file: type=lint
mixin _$IndividualMessagesDaoMixin on DatabaseAccessor<AppDatabase> {
  $IndividualMessagesTable get individualMessages =>
      attachedDatabase.individualMessages;
  IndividualMessagesDaoManager get managers =>
      IndividualMessagesDaoManager(this);
}

class IndividualMessagesDaoManager {
  final _$IndividualMessagesDaoMixin _db;
  IndividualMessagesDaoManager(this._db);
  $$IndividualMessagesTableTableManager get individualMessages =>
      $$IndividualMessagesTableTableManager(
        _db.attachedDatabase,
        _db.individualMessages,
      );
}
