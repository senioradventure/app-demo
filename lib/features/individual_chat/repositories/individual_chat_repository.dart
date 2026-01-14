import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path/path.dart';
import 'package:senior_circle/core/local_db/app_database.dart'; // Adjust path if needed
import 'package:senior_circle/core/local_db/tables/individual_messages_table.dart';
import 'package:senior_circle/features/individual_chat/model/individual_chat_message_model.dart';
import 'package:senior_circle/features/individual_chat/model/individual_user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:senior_circle/core/local_db/daos/individual_messages_dao.dart';

class IndividualChatRepository {
  final supabase.SupabaseClient _client = supabase.Supabase.instance.client;
  final IndividualMessagesDao _dao = AppDatabase.instance.individualMessagesDao;

  /// Loads messages from Supabase, syncs them to Drift, and returns the list.
  /// Used for initial load.
  Future<List<IndividualChatMessageModel>> loadMessages(
    String conversationId,
  ) async {
    try {
      final userId = _client.auth.currentUser!.id;

      // 1. Fetch from Supabase
      final response = await _client
          .from('messages')
          .select('''
          *,
          message_reactions(*),
          hidden_messages!left(
            message_id,
            user_id
          )
        ''')
          .eq('conversation_id', conversationId)
          .isFilter('deleted_at', null)
          .or('expires_at.is.null,expires_at.gt.${DateTime.now().toUtc()}')
          .eq('hidden_messages.user_id', userId)
          .order('created_at', ascending: true);

      final List<dynamic> data = (response as List).where((e) {
        return e['hidden_messages'] == null ||
            (e['hidden_messages'] as List).isEmpty;
      }).toList();

      final models = data
          .map((e) => IndividualChatMessageModel.fromSupabase(e))
          .toList();

      for (final msg in models) {
        await _dao.upsertMessage(_toCompanion(msg, conversationId));
      }

      return models;
    } catch (e) {
      final localMsgs = await _dao.watchMessages(conversationId).first;
      if (localMsgs.isNotEmpty) {
        return localMsgs.map(_fromRow).toList();
      }
      rethrow;
    }
  }

  /// Watch messages from local Drift DB
  Stream<List<IndividualChatMessageModel>> watchMessages(
    String conversationId,
  ) {
    return _dao.watchMessages(conversationId).map((rows) {
      return rows.map(_fromRow).toList();
    });
  }

  /// Upload any media (image / file / voice)
  Future<String> uploadMedia({
    required File file,
    required String folder, // images | files | voice
  }) async {
    final fileName =
        'messages/$folder/${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}';

    await _client.storage.from('media').upload(fileName, file);

    return _client.storage.from('media').getPublicUrl(fileName);
  }

  /// Insert message row
  Future<IndividualChatMessageModel> insertMessage({
    required String conversationId,
    required String mediaType,
    String content = '',
    String? mediaUrl,
    String? replyToMessageId,
  }) async {
    final response = await _client
        .from('messages')
        .insert({
          'conversation_id': conversationId,
          'sender_id': _client.auth.currentUser!.id,
          'content': content,
          'media_url': mediaUrl,
          'media_type': mediaType,
          'reply_to_message_id': replyToMessageId,
        })
        .select()
        .single();

    final model = IndividualChatMessageModel.fromSupabase(response);
    // Sync to Drift
    await _dao.upsertMessage(_toCompanion(model, conversationId));

    return model;
  }

  Future<IndividualChatMessageModel> sendMessage({
    required String conversationId,
    required String content,
    required String mediaType,
    String? mediaUrl,
    String? replyToMessageId,
  }) async {
    return insertMessage(
      conversationId: conversationId,
      mediaType: mediaType,
      content: content,
      mediaUrl: mediaUrl,
      replyToMessageId: replyToMessageId,
    );
  }

  Future<void> addReaction({
    required String messageId,
    required String reaction,
  }) async {
    final userId = _client.auth.currentUser!.id;

    final existingResponse = await _client
        .from('message_reactions')
        .select()
        .eq('message_id', messageId)
        .eq('user_id', userId);

    final existing = (existingResponse as List);

    if (existing.isNotEmpty) {
      await _client
          .from('message_reactions')
          .delete()
          .eq('id', existing.first['id']);

      if (existing.first['reaction'] == reaction) {
        return;
      }
    }

    await _client.from('message_reactions').insert({
      'message_id': messageId,
      'user_id': userId,
      'reaction': reaction,
    });

    // Note: Reactions are not stored in Drift messages table
  }

  Future<void> starMessage({
    required IndividualChatMessageModel message,
  }) async {
    final userId = _client.auth.currentUser!.id;

    await _client.from('saved_messages').insert({
      'user_id': userId,
      'message_id': message.id,
      'sender_id': message.senderId,
      'content': message.content,
      'media_url': message.mediaUrl,
      'media_type': message.mediaType,
    });
  }

  Future<void> deleteMessageForEveryone(String messageId) async {
    await _client
        .from('messages')
        .update({'deleted_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', messageId);

    // Sync to Drift
    await _dao.softDelete(messageId);
  }

  Future<void> deleteMessageForMe(String messageId) async {
    await _client.rpc(
      'delete_message_for_me',
      params: {'p_message_id': messageId},
    );
    await _dao.softDelete(messageId);
  }

  Future<UserProfile> getUserProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select('id, full_name, avatar_url, locations(name)')
        .eq('id', userId)
        .single();

    return UserProfile.fromSupabase(response);
  }

  Future<dynamic> getOrCreateIndividualChatWithFriend(String friendId) async {}

  Future<String> getCurrentUserId() async {
    return _client.auth.currentUser!.id;
  }

  // ---------------------------------------------------------------------------
  // MAPPERS
  // ---------------------------------------------------------------------------

  IndividualMessagesCompanion _toCompanion(
    IndividualChatMessageModel model,
    String conversationId,
  ) {
    return IndividualMessagesCompanion(
      id: Value(model.id),
      senderId: Value(model.senderId),
      content: Value(model.content),
      mediaUrl: Value(model.mediaUrl),
      mediaType: Value(model.mediaType),
      conversationId: Value(conversationId),
      replyToMessageId: Value(model.replyToMessageId),
      createdAt: Value(model.createdAt),
  
    );
  }

  IndividualChatMessageModel _fromRow(IndividualMessage row) {
    return IndividualChatMessageModel(
      id: row.id,
      senderId: row.senderId,
      content: row.content,
      mediaUrl: row.mediaUrl,
      mediaType: row.mediaType,
      createdAt: row.createdAt,
      replyToMessageId: row.replyToMessageId,
      reactions: [], // Drift does not store reactions
    );
  }
}
