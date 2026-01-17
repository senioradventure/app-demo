import 'package:drift/drift.dart';
import 'chat_details_table.dart';

class ChatMembersTable extends Table {
  TextColumn get userId => text()(); // Corresponds to profile id usually
  TextColumn get chatId => text().references(ChatDetailsTable, #id)();
  TextColumn get name => text().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get role => text()(); // 'admin', 'member', etc.

  @override
  Set<Column> get primaryKey => {userId, chatId};
}
