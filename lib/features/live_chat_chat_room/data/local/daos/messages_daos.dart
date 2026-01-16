import 'package:drift/drift.dart';

import  'package:senior_circle/features/live_chat_chat_room/data/local/database.dart';

import  'package:senior_circle/features/live_chat_chat_room/data/local/tables/messages_table.dart';
import 'package:uuid/uuid.dart';
part 'messages_daos.g.dart';

@DriftAccessor(tables: [Messages])
class MessagesDao extends DatabaseAccessor<AppDatabase>
    with _$MessagesDaoMixin {

  MessagesDao(AppDatabase db) : super(db);

  Stream<List<Message>> watchMessages(String roomId) {
    return (select(messages)
          ..where((m) => m.roomId.equals(roomId))
          ..orderBy([(m) => OrderingTerm.asc(m.createdAt)]))
        .watch();
  }

  Future<void> insertLocalMessage({
    required String roomId,
    required String senderId,
    required String content,
  }) {
    final id = const Uuid().v4();
    return into(messages).insert(
      MessagesCompanion.insert(
         id: id,
        roomId: roomId,
        senderId: senderId,
        content: content,
      ),
    );
  }
}