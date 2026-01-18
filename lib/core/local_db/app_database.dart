import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/individual_messages_table.dart';
import 'tables/message_reactions_table.dart';
import 'tables/chatroom_table.dart';
import 'tables/messages_table.dart';
import 'daos/individual_messages_dao.dart';
import 'daos/message_reactions_dao.dart';
import 'daos/chatroom_daos.dart';
import 'daos/messages_daos.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [IndividualMessages, MessageReactions, ChatRooms, Messages],
  daos: [IndividualMessagesDao, MessageReactionsDao, ChatRoomsDao, MessagesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  static final AppDatabase instance = AppDatabase();

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        // Migration from version 1 to 2: add message_reactions table
        await m.createTable(messageReactions);
      }
      if (from < 3) {
        // Migration from version 2 to 3: add local_media_path column
        await m.addColumn(
          individualMessages,
          individualMessages.localMediaPath,
        );
      }
      if (from < 4) {
        // Migration from version 3 to 4: add chatrooms and messages tables
        await m.createTable(chatRooms);
        await m.createTable(messages);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
