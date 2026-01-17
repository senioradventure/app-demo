import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'daos/chatroom_daos.dart';
import 'daos/messages_daos.dart';

import 'package:senior_circle/features/live_chat_chat_room/data/local/tables/chatroom_table.dart';
import 'package:senior_circle/features/live_chat_chat_room/data/local/tables/messages_table.dart';

import 'package:senior_circle/features/chat/data/local/tables/chat_details_table.dart';
import 'package:senior_circle/features/chat/data/local/tables/chat_members_table.dart';
import 'package:senior_circle/features/chat/data/local/daos/chat_details_dao.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [ChatRooms, Messages, ChatDetailsTable, ChatMembersTable],
  daos: [ChatRoomsDao, MessagesDao, ChatDetailsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(chatDetailsTable);
        await m.createTable(chatMembersTable);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'live_chat.db'));
    return NativeDatabase(file);
  });
}
