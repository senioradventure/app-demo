import 'package:drift/drift.dart';

class ChatRooms extends Table {
  TextColumn get roomId => text()();
  TextColumn get name => text()();
  TextColumn get location => text().nullable()();
  IntColumn get userCount => integer().withDefault(const Constant(0))();
  BoolColumn get isLive => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {roomId};
}
