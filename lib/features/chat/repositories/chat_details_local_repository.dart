import 'package:senior_circle/features/chat/data/local/daos/chat_details_dao.dart';
// These imports will be available after generation
import 'package:senior_circle/features/live_chat_chat_room/data/local/database.dart';
import '../models/chat_details_models.dart';
import 'package:drift/drift.dart';

class ChatDetailsLocalRepository {
  final ChatDetailsDao _dao;

  ChatDetailsLocalRepository(this._dao);

  Future<ChatDetailsModel?> getChatDetails(String chatId) async {
    final data = await _dao.getChatDetail(chatId);
    if (data == null) return null;

    final type = data.type == 'room' ? ChatType.room : ChatType.circle;

    if (type == ChatType.room) {
      return RoomDetails(
        id: data.id,
        name: data.name,
        imageUrl: data.imageUrl,
        adminId: data.adminId,
        description: data.description,
      );
    } else {
      return CircleDetails(
        id: data.id,
        name: data.name,
        imageUrl: data.imageUrl,
        adminId: data.adminId,
      );
    }
  }

  Future<void> saveChatDetails(ChatDetailsModel details) async {
    String? description;
    if (details is RoomDetails) {
      description = details.description;
    }

    final companion = ChatDetailsTableCompanion(
      id: Value(details.id),
      name: Value(details.name),
      imageUrl: Value(details.imageUrl),
      adminId: Value(details.adminId),
      type: Value(details.type == ChatType.room ? 'room' : 'circle'),
      description: Value(description),
    );

    await _dao.insertChatDetail(companion);
  }

  Future<List<ChatMember>> getMembers(String chatId) async {
    final rows = await _dao.getMembers(chatId);
    return rows.map((row) {
      ChatRole role = ChatRole.member;
      if (row.role == 'admin') role = ChatRole.admin;

      return ChatMember(
        userId: row.userId,
        name: row.name,
        avatarUrl: row.avatarUrl,
        role: role,
      );
    }).toList();
  }

  Future<void> saveMembers(String chatId, List<ChatMember> members) async {
    // Ideally clear old members or update existing
    // We already have clearMembers in DAO or insertOnConflictUpdate
    // Let's clear first to remove removed members?
    // Or just insert. If we want to support removal, clearing is safer for full sync.
    // However, clearing might cause flickering if observing.
    // For now, let's clear then insert.
    await _dao.clearMembers(chatId);

    final companions = members.map((m) {
      return ChatMembersTableCompanion(
        userId: Value(m.userId),
        chatId: Value(chatId),
        name: Value(m.name),
        avatarUrl: Value(m.avatarUrl),
        role: Value(m.role == ChatRole.admin ? 'admin' : 'member'),
      );
    }).toList();

    await _dao.insertMembers(companions);
  }
}
