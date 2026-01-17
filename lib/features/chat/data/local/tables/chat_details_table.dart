import 'package:drift/drift.dart';

class ChatDetailsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get adminId => text().nullable()();
  TextColumn get type => text()(); // 'room' or 'circle'
  // Only for rooms, typically
  TextColumn get description => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
