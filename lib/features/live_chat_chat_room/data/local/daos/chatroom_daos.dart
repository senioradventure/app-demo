import 'package:drift/drift.dart';
import  'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import  'package:senior_circle/features/live_chat_chat_room/data/local/database.dart';

import  'package:senior_circle/features/live_chat_chat_room/data/local/tables/chatroom_table.dart';

part 'chatroom_daos.g.dart';
@DriftAccessor(tables: [ChatRooms])
class ChatRoomsDao extends DatabaseAccessor<AppDatabase>
    with _$ChatRoomsDaoMixin {

  ChatRoomsDao(AppDatabase db) : super(db);

  Stream<List<ChatRoom>> watchRooms() {
    return select(chatRooms).watch();
  }

  Future<void> insertRoom(ChatRoomsCompanion room) {
    return into(chatRooms).insertOnConflictUpdate(room);
  }

  Future<void> clearRooms() {
    return delete(chatRooms).go();
  }
}