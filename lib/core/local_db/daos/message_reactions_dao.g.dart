// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_reactions_dao.dart';

// ignore_for_file: type=lint
mixin _$MessageReactionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $MessageReactionsTable get messageReactions =>
      attachedDatabase.messageReactions;
  MessageReactionsDaoManager get managers => MessageReactionsDaoManager(this);
}

class MessageReactionsDaoManager {
  final _$MessageReactionsDaoMixin _db;
  MessageReactionsDaoManager(this._db);
  $$MessageReactionsTableTableManager get messageReactions =>
      $$MessageReactionsTableTableManager(
        _db.attachedDatabase,
        _db.messageReactions,
      );
}
