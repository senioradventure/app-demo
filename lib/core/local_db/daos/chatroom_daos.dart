import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/chatroom_table.dart';

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
