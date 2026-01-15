import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/individual_messages_table.dart';
import 'tables/message_reactions_table.dart';
import 'daos/individual_messages_dao.dart';
import 'daos/message_reactions_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [IndividualMessages, MessageReactions],
  daos: [IndividualMessagesDao, MessageReactionsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  static final AppDatabase instance = AppDatabase();

  @override
  int get schemaVersion => 2;

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
