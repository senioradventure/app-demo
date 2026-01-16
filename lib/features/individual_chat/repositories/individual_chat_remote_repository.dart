import 'dart:io';

import 'package:path/path.dart';
import 'package:senior_circle/features/individual_chat/model/individual_chat_message_model.dart';
import 'package:senior_circle/features/individual_chat/model/individual_user_profile_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

/// Remote repository for individual chat using Supabase
/// Handles all remote API operations for messages, reactions, and media
class IndividualChatRemoteRepository {
  final supabase.SupabaseClient _client = supabase.Supabase.instance.client;

  supabase.RealtimeChannel? _messagesChannel;
  supabase.RealtimeChannel? _reactionsChannel;

  /// Fetch messages from Supabase with reactions and hidden messages filter
  Future<List<IndividualChatMessageModel>> fetchMessages(
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

    final List<dynamic> data = (response as List).where((e) {
      return e['hidden_messages'] == null ||
          (e['hidden_messages'] as List).isEmpty;
    }).toList();

    return data.map((e) => IndividualChatMessageModel.fromSupabase(e)).toList();
  }

  /// Insert a new message to Supabase
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

  /// Upload media (image / file / voice) to Supabase Storage
  Future<String> uploadMedia({
    required File file,
    required String folder, // images | files | voice
  }) async {
    final fileName =
        'messages/$folder/${DateTime.now().millisecondsSinceEpoch}_${basename(file.path)}';

    await _client.storage.from('media').upload(fileName, file);

    return _client.storage.from('media').getPublicUrl(fileName);
  }

  /// Add a reaction to a message on Supabase
  /// Returns the reaction data if inserted, or null if toggled off
  Future<Map<String, dynamic>?> addReaction({
    required String messageId,
    required String reaction,
  }) async {
    final userId = _client.auth.currentUser!.id;

    // Check if user already has a reaction on this message
    final existingResponse = await _client
        .from('message_reactions')
        .select()
        .eq('message_id', messageId)
        .eq('user_id', userId);

    final existing = (existingResponse as List);

    if (existing.isNotEmpty) {
      final existingReaction = existing.first['reaction'];
      final existingId = existing.first['id'];

      // Delete from Supabase
      await _client.from('message_reactions').delete().eq('id', existingId);

      // If same reaction, toggle off (return null to indicate deletion)
      if (existingReaction == reaction) {
        return null;
      }
    }

    // Insert new reaction into Supabase
    final response = await _client
        .from('message_reactions')
        .insert({
          'message_id': messageId,
          'user_id': userId,
          'reaction': reaction,
        })
        .select()
        .single();

    return response;
  }

  /// Remove a reaction from a message on Supabase
  Future<void> removeReaction({
    required String messageId,
    required String reaction,
  }) async {
    final userId = _client.auth.currentUser!.id;

    // Find the reaction in Supabase
    final existingResponse = await _client
        .from('message_reactions')
        .select()
        .eq('message_id', messageId)
        .eq('user_id', userId)
        .eq('reaction', reaction);

    final existing = (existingResponse as List);

    if (existing.isEmpty) return;

    // Delete from Supabase
    await _client
        .from('message_reactions')
        .delete()
        .eq('id', existing.first['id']);
  }

  /// Star/save a message for the current user
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

  /// Soft delete a message for everyone
  Future<void> deleteMessageForEveryone(String messageId) async {
    await _client
        .from('messages')
        .update({'deleted_at': DateTime.now().toUtc().toIso8601String()})
        .eq('id', messageId);
  }

  /// Delete a message for the current user only (via RPC)
  Future<void> deleteMessageForMe(String messageId) async {
    await _client.rpc(
      'delete_message_for_me',
      params: {'p_message_id': messageId},
    );
  }

  /// Fetch user profile from Supabase
  Future<UserProfile> getUserProfile(String userId) async {
    final response = await _client
        .from('profiles')
        .select('id, full_name, avatar_url, locations(name)')
        .eq('id', userId)
        .single();

    return UserProfile.fromSupabase(response);
  }

  /// Get current authenticated user ID
  Future<String> getCurrentUserId() async {
    return _client.auth.currentUser!.id;
  }

  /// Subscribe to realtime changes for messages in a conversation
  void subscribeToMessagesRealtime(
    String conversationId,
    Function(IndividualChatMessageModel) onNewMessage,
  ) {
    _messagesChannel?.unsubscribe();

    _messagesChannel = _client
        .channel('conversation_$conversationId')
        .onPostgresChanges(
          event: supabase.PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: supabase.PostgresChangeFilter(
            type: supabase.PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) {
            final newMessage = IndividualChatMessageModel.fromSupabase(
              payload.newRecord,
            );
            onNewMessage(newMessage);
          },
        )
        .subscribe();
  }

  /// Subscribe to realtime changes for reactions
  /// Callback receives the reaction data and a boolean indicating if it's a delete
  void subscribeToReactionsRealtime(
    String conversationId,
    Function(Map<String, dynamic>, bool isDelete) onReactionChange,
  ) {
    _reactionsChannel?.unsubscribe();

    _reactionsChannel = _client
        .channel('reactions_$conversationId')
        .onPostgresChanges(
          event: supabase.PostgresChangeEvent.insert,
          schema: 'public',
          table: 'message_reactions',
          callback: (payload) {
            onReactionChange(payload.newRecord, false);
          },
        )
        .onPostgresChanges(
          event: supabase.PostgresChangeEvent.delete,
          schema: 'public',
          table: 'message_reactions',
          callback: (payload) {
            onReactionChange(payload.oldRecord, true);
          },
        )
        .subscribe();
  }

  /// Unsubscribe from all realtime channels
  void unsubscribeFromRealtime() {
    _messagesChannel?.unsubscribe();
    _reactionsChannel?.unsubscribe();
  }
}
