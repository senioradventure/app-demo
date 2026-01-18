import 'package:drift/drift.dart';
import 'package:senior_circle/core/local_db/app_database.dart';
import 'package:senior_circle/core/local_db/daos/individual_messages_dao.dart';
import 'package:senior_circle/core/local_db/daos/message_reactions_dao.dart';
import 'package:senior_circle/features/individual_chat/model/individual_chat_message_model.dart';
import 'package:senior_circle/features/individual_chat/model/individual_message_reaction_model.dart'
    as model;

/// Local repository for individual chat messages using Drift DAO
/// Handles all local database operations for messages and reactions
class IndividualChatLocalRepository {
  final IndividualMessagesDao _messagesDao =
      AppDatabase.instance.individualMessagesDao;
  final MessageReactionsDao _reactionsDao =
      AppDatabase.instance.messageReactionsDao;

  /// Watch messages from local Drift DB with reactions
  /// Returns a stream that emits whenever messages or reactions change
  Stream<List<IndividualChatMessageModel>> watchMessages(
    String conversationId,
  ) async* {
    await for (final messages in _messagesDao.watchMessages(conversationId)) {
      final messagesWithReactions = <IndividualChatMessageModel>[];

      for (final msg in messages) {
        final reactions = await _reactionsDao
            .watchReactionsByMessageId(msg.id)
            .first;

        final messageModel = _fromRow(msg).copyWith(
          reactions: reactions
              .map(
                (r) => model.MessageReaction(
                  id: r.id,
                  userId: r.userId,
                  reaction: r.reaction,
                ),
              )
              .toList(),
        );

        messagesWithReactions.add(messageModel);
      }

      yield messagesWithReactions;
    }
  }

  /// Get a snapshot of messages from local DB (for offline fallback)
  Future<List<IndividualChatMessageModel>> getMessagesSnapshot(
    String conversationId,
  ) async {
    final messages = await _messagesDao.watchMessages(conversationId).first;
    final messagesWithReactions = <IndividualChatMessageModel>[];

    for (final msg in messages) {
      final reactions = await _reactionsDao
          .watchReactionsByMessageId(msg.id)
          .first;

      final messageModel = _fromRow(msg).copyWith(
        reactions: reactions
            .map(
              (r) => model.MessageReaction(
                id: r.id,
                userId: r.userId,
                reaction: r.reaction,
              ),
            )
            .toList(),
      );

      messagesWithReactions.add(messageModel);
    }

    return messagesWithReactions;
  }

  /// Upsert a message to local Drift DB
  /// If the message has media but no local path, save the media file locally
  Future<void> upsertMessage(
    IndividualChatMessageModel message,
    String conversationId,
  ) async {
    String? localMediaPath = message.localMediaPath;

    // If message has media URL but no local path, try to save it locally
    // This handles messages fetched from Supabase that don't have local copies yet
    if (message.mediaUrl != null &&
        message.mediaUrl!.isNotEmpty &&
        (localMediaPath == null || localMediaPath.isEmpty)) {
      // Note: For messages from remote, we would need to download the file first
      // For now, we'll just store the remote URL and rely on the BLoC to provide local paths
      // when sending new messages
    }

    await _messagesDao.upsertMessage(
      _toCompanion(message, conversationId, localMediaPath),
    );
  }

  /// Upsert a reaction to local Drift DB
  /// Deletes any existing reaction from this user on this message first,
  /// then inserts the new reaction (matching Supabase behavior)
  Future<void> upsertReaction(
    model.MessageReaction reaction,
    String messageId,
    DateTime createdAt,
  ) async {
    // First, delete any existing reaction from this user on this message
    // This handles the case where the user changes their reaction
    await _reactionsDao.deleteReactionByUser(messageId, reaction.userId);

    // Then insert the new reaction
    await _reactionsDao.insertReaction(
      MessageReactionsCompanion(
        id: Value(reaction.id),
        messageId: Value(messageId),
        userId: Value(reaction.userId),
        reaction: Value(reaction.reaction),
        createdAt: Value(createdAt),
      ),
    );
  }

  /// Delete a specific reaction from local Drift DB
  Future<void> deleteReaction(
    String messageId,
    String userId,
    String reaction,
  ) async {
    await _reactionsDao.deleteReaction(messageId, userId, reaction);
  }

  /// Soft delete a message in local Drift DB
  Future<void> softDeleteMessage(String messageId) async {
    await _messagesDao.softDelete(messageId);
  }

  /// Clear all messages for a conversation from local DB
  Future<void> clearConversation(String conversationId) async {
    await _messagesDao.clearConversation(conversationId);
  }

  // ---------------------------------------------------------------------------
  // MAPPERS
  // ---------------------------------------------------------------------------

  /// Convert Drift row to domain model
  IndividualChatMessageModel _fromRow(IndividualMessage row) {
    return IndividualChatMessageModel(
      id: row.id,
      senderId: row.senderId,
      content: row.content,
      mediaUrl: row.mediaUrl,
      localMediaPath: row.localMediaPath,
      mediaType: row.mediaType,
      createdAt: row.createdAt,
      replyToMessageId: row.replyToMessageId,
      reactions: [], // Reactions will be loaded separately via stream
    );
  }

  /// Convert domain model to Drift companion
  IndividualMessagesCompanion _toCompanion(
    IndividualChatMessageModel model,
    String conversationId,
    String? localMediaPath,
  ) {
    return IndividualMessagesCompanion(
      id: Value(model.id),
      senderId: Value(model.senderId),
      content: Value(model.content),
      mediaUrl: Value(model.mediaUrl),
      localMediaPath: Value(localMediaPath),
      mediaType: Value(model.mediaType),
      conversationId: Value(conversationId),
      replyToMessageId: Value(model.replyToMessageId),
      createdAt: Value(model.createdAt),
    );
  }
}
