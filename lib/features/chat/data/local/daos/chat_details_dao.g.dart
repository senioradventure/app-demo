// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_details_dao.dart';

// ignore_for_file: type=lint
mixin _$ChatDetailsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ChatDetailsTableTable get chatDetailsTable =>
      attachedDatabase.chatDetailsTable;
  $ChatMembersTableTable get chatMembersTable =>
      attachedDatabase.chatMembersTable;
  ChatDetailsDaoManager get managers => ChatDetailsDaoManager(this);
}

class ChatDetailsDaoManager {
  final _$ChatDetailsDaoMixin _db;
  ChatDetailsDaoManager(this._db);
  $$ChatDetailsTableTableTableManager get chatDetailsTable =>
      $$ChatDetailsTableTableTableManager(
        _db.attachedDatabase,
        _db.chatDetailsTable,
      );
  $$ChatMembersTableTableTableManager get chatMembersTable =>
      $$ChatMembersTableTableTableManager(
        _db.attachedDatabase,
        _db.chatMembersTable,
      );
}
