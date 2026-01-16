import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class FriendsTable extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get username => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [FriendsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'my_database');
  }
}
