import 'dart:io';

import 'package:senior_circle/features/individual_chat/model/individual_chat_message_model.dart';
import 'package:senior_circle/features/individual_chat/model/individual_user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';

class IndividualChatRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<IndividualChatMessageModel>> loadMessages(
    String conversationId,
  ) async {
    final userId = _client.auth.currentUser!.id;

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

    return (response as List)
        .where(
          (e) =>
              e['hidden_messages'] == null ||
              (e['hidden_messages'] as List).isEmpty,
        )
        .map((e) => IndividualChatMessageModel.fromSupabase(e))
        .toList();
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

    return IndividualChatMessageModel.fromSupabase(response);
  }

  Future<IndividualChatMessageModel> sendMessage({
    required String conversationId,
    required String content,
    required String mediaType,
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

    return IndividualChatMessageModel.fromSupabase(response);
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
  }

  Future<void> starMessage({
    required IndividualChatMessageModel message,
    String? source,
    String? sourceType,
  }) async {
    final userId = Supabase.instance.client.auth.currentUser!.id;

    await Supabase.instance.client.from('saved_messages').insert({
      'user_id': userId,
      'message_id': message.id,
      'sender_id': message.senderId,
      'content': message.content,
      'media_url': message.mediaUrl,
      'media_type': message.mediaType,
      'source': source,
      'source_type': sourceType,
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> deleteMessageForEveryone(String messageId) async {
    await _client
        .from('messages')
        .update({'deleted_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', messageId);
  }

  Future<void> deleteMessageForMe(String messageId) async {
    await _client.rpc(
      'delete_message_for_me',
      params: {'p_message_id': messageId},
    );
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
}
