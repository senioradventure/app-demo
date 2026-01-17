import 'package:drift/drift.dart';
import '../../../../live_chat_chat_room/data/local/database.dart';
import '../tables/chat_details_table.dart';
import '../tables/chat_members_table.dart';

part 'chat_details_dao.g.dart';

@DriftAccessor(tables: [ChatDetailsTable, ChatMembersTable])
class ChatDetailsDao extends DatabaseAccessor<AppDatabase>
    with _$ChatDetailsDaoMixin {
  ChatDetailsDao(AppDatabase db) : super(db);

  // Chat Details Methods
  Future<void> insertChatDetail(ChatDetailsTableCompanion chatDetail) =>
      into(chatDetailsTable).insertOnConflictUpdate(chatDetail);

  Future<ChatDetailsTableData?> getChatDetail(String id) => (select(
    chatDetailsTable,
  )..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // Chat Members Methods
  Future<void> insertMembers(List<ChatMembersTableCompanion> members) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(chatMembersTable, members);
    });
  }

  Future<void> clearMembers(String chatId) => (delete(
    chatMembersTable,
  )..where((tbl) => tbl.chatId.equals(chatId))).go();

  Future<List<ChatMembersTableData>> getMembers(String chatId) => (select(
    chatMembersTable,
  )..where((tbl) => tbl.chatId.equals(chatId))).get();

  Future<void> deleteMember(String chatId, String userId) =>
      (delete(chatMembersTable)..where(
            (tbl) => tbl.chatId.equals(chatId) & tbl.userId.equals(userId),
          ))
          .go();
}
