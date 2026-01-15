import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'daos/chatroom_daos.dart';
import 'daos/messages_daos.dart';

import  'package:senior_circle/features/live_chat_chat_room/data/local/tables/chatroom_table.dart';
import  'package:senior_circle/features/live_chat_chat_room/data/local/tables/messages_table.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [ChatRooms, Messages],
  daos: [ChatRoomsDao, MessagesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'live_chat.db'));
    return NativeDatabase(file);
  });
}