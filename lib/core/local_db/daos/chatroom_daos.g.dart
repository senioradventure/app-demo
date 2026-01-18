// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatroom_daos.dart';

// ignore_for_file: type=lint
mixin _$ChatRoomsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ChatRoomsTable get chatRooms => attachedDatabase.chatRooms;
  ChatRoomsDaoManager get managers => ChatRoomsDaoManager(this);
}

class ChatRoomsDaoManager {
  final _$ChatRoomsDaoMixin _db;
  ChatRoomsDaoManager(this._db);
  $$ChatRoomsTableTableManager get chatRooms =>
      $$ChatRoomsTableTableManager(_db.attachedDatabase, _db.chatRooms);
}
