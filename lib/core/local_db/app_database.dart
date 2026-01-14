import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'tables/individual_messages_table.dart';
import 'daos/individual_messages_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [IndividualMessages], daos: [IndividualMessagesDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  static final AppDatabase instance = AppDatabase();

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'app_database.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
