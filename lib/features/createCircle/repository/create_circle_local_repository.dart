import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../model/friend_model.dart';

class CreateCircleLocalRepository {
  final FriendDatabase _db;

  CreateCircleLocalRepository(this._db);

  Future<List<Friend>> getFriends() async {
    final result = await _db.select(_db.friendsTable).get();
    return result
        .map(
          (row) => Friend(
            id: row.id,
            fullName: row.fullName,
            avatarUrl: row.avatarUrl,
            username: row.username,
          ),
        )
        .toList();
  }

  Future<void> cacheFriends(List<Friend> friends) async {
    await _db.transaction(() async {
      await _db.delete(_db.friendsTable).go();
      await _db.batch((batch) {
        batch.insertAll(
          _db.friendsTable,
          friends.map(
            (f) => FriendsTableCompanion.insert(
              id: f.id,
              fullName: f.fullName,
              username: f.username,
              avatarUrl: Value(f.avatarUrl),
            ),
          ),
        );
      });
    });
  }
}
