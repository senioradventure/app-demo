import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../models/group_message_model.dart';
import '../mappers/reaction_mapper.dart';

class GroupChatRepository {
  final SupabaseClient _client;

  GroupChatRepository(this._client);

  Future<List<GroupMessage>> fetchGroupMessages({
    required String circleId,
  }) async {
    try {
      final messageRows = await _fetchMessageRows(circleId);
      if (messageRows.isEmpty) return [];

      final reactionsByMessage = await _fetchReactions(messageRows);
      final savedMessageIds = await _fetchSavedMessageIds(messageRows);
      return _buildMessageTree(
        messageRows,
        reactionsByMessage,
        savedMessageIds,
      );
    } catch (e, stack) {
      debugPrint('🟥 [GroupChatRepo] ERROR: $e');
      debugPrint('🟥 [GroupChatRepo] STACKTRACE:\n$stack');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchMessageRows(String circleId) async {
    final userId = _client.auth.currentUser!.id;

    final rows = await _client
        .from('messages')
        .select('''
        id, sender_id, content, media_url, media_type, reply_to_message_id, created_at,
        profiles!messages_sender_id_fkey (id, full_name, avatar_url),
        hidden_messages!left (message_id, user_id)
      ''')
        .eq('circle_id', circleId)
        .isFilter('deleted_at', null)
        .eq('hidden_messages.user_id', userId)
        .order('created_at', ascending: false);

    return (rows as List)
        .where((e) => (e['hidden_messages'] as List).isEmpty)
        .cast<Map<String, dynamic>>()
        .toList();
  }

  Future<Map<String, List<Map<String, dynamic>>>> _fetchReactions(
    List<Map<String, dynamic>> messageRows,
  ) async {
    final messageIds = messageRows
        .map<String>((m) => m['id'] as String)
        .toList();

    debugPrint(
      '🟩 [GroupChatRepo] Collecting reactions for ${messageIds.length} messages',
    );

    final reactionRows = await _client
        .from('message_reactions')
        .select('message_id, user_id, reaction')
        .inFilter('message_id', messageIds);

    debugPrint(
      '🟩 [GroupChatRepo] Reaction rows fetched: ${reactionRows.length}',
    );

    final Map<String, List<Map<String, dynamic>>> reactionsByMessage = {};
    for (final row in reactionRows) {
      final messageId = row['message_id'] as String;
      reactionsByMessage.putIfAbsent(messageId, () => []);
      reactionsByMessage[messageId]!.add(row);
    }

    return reactionsByMessage;
  }

  Future<Set<String>> _fetchSavedMessageIds(
    List<Map<String, dynamic>> messageRows,
  ) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return {};

    final messageIds = messageRows
        .map<String>((m) => m['id'] as String)
        .toList();

    if (messageIds.isEmpty) return {};

    final savedRows = await _client
        .from('saved_messages')
        .select('message_id')
        .eq('user_id', userId)
        .inFilter('message_id', messageIds);

    return savedRows.map<String>((r) => r['message_id'] as String).toSet();
  }

  List<GroupMessage> _buildMessageTree(
    List<Map<String, dynamic>> messageRows,
    Map<String, List<Map<String, dynamic>>> reactionsByMessage,
    Set<String> savedMessageIds,
  ) {
    final List<GroupMessage> allMessagesList = messageRows.map((row) {
      final id = row['id'] as String;
      return GroupMessage(
        id: id,
        senderId: row['sender_id'] ?? '',
        senderName: row['profiles']?['full_name'] ?? 'Unknown',
        mediaType: row['media_type'] ?? 'text',
        avatar: row['profiles']?['avatar_url'],
        text: row['content'],
        imagePath: row['media_type'] == 'image' ? row['media_url'] : null,
        time: row['created_at'] as String,
        reactions: ReactionMapper.aggregate(reactionsByMessage[id] ?? []),
        replies: const [],
        replyToMessageId: row['reply_to_message_id'] as String?,
        isStarred: savedMessageIds.contains(id),
      );
    }).toList();

    final Map<String, List<GroupMessage>> repliesMap = {};

    for (var m in allMessagesList) {
      if (m.replyToMessageId != null) {
        repliesMap.putIfAbsent(m.replyToMessageId!, () => []).add(m);
      }
    }

    return allMessagesList
        .where((m) => m.replyToMessageId == null)
        .map(
          (m) =>
              m.copyWith(replies: (repliesMap[m.id] ?? []).reversed.toList()),
        )
        .toList();
  }

  Future<GroupMessage> sendGroupMessage({
    required String circleId,
    required String content,
    String? mediaUrl,
    String mediaType = 'text',
    String? replyToMessageId,
  }) async {
    final senderId = _client.auth.currentUser!.id;

    final response = await _client
        .from('messages')
        .insert({
          'circle_id': circleId,
          'sender_id': senderId,
          'content': content,
          'media_url': mediaUrl,
          'media_type': mediaType,
          'reply_to_message_id': replyToMessageId,
        })
        .select('*, profiles!messages_sender_id_fkey(full_name, avatar_url)')
        .single();

    // debugPrint('🟩 [GroupChatRepo] Group message inserted and returned');

    return GroupMessage.fromSupabase(
      messageRow: response,
      reactions: const [],
      replies: const [],
    );
  }

  Future<void> toggleGroupReaction({
    required String messageId,
    required String emoji,
    required String userId,
  }) async {
    try {
      final existing = await _client
          .from('message_reactions')
          .select()
          .eq('message_id', messageId)
          .eq('user_id', userId)
          .eq('reaction', emoji)
          .maybeSingle();

      if (existing != null) {
        await _client
            .from('message_reactions')
            .delete()
            .eq('id', existing['id']);
      } else {
        await _client.from('message_reactions').insert({
          'message_id': messageId,
          'user_id': userId,
          'reaction': emoji,
        });
      }
    } catch (e, stack) {
      debugPrint('🟥 [GroupChatRepo] toggleGroupReaction ERROR: $e');
      debugPrint('🟥 [GroupChatRepo] STACKTRACE:\n$stack');
      rethrow;
    }
  }

  Future<String> uploadCircleImage(File file) async {
    debugPrint('🟦 [Upload] Method entered');
    debugPrint('🟦 [Upload] File path: ${file.path}');
    debugPrint('🟦 [Upload] File exists: ${file.existsSync()}');
    debugPrint('🟦 [Upload] File size: ${file.lengthSync()} bytes');

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

    final storagePath = 'circle_images/$fileName';

    debugPrint('🟦 [Upload] Storage path: $storagePath');
    debugPrint('🟦 [Upload] Bucket: media');

    try {
      debugPrint('🟨 [Upload] Starting Supabase upload...');

      final response = await _client.storage
          .from('media')
          .upload(
            storagePath,
            file,
            fileOptions: const FileOptions(upsert: false),
          );

      debugPrint('🟩 [Upload] Upload completed');
      debugPrint('🟩 [Upload] Response: $response');

      final publicUrl = _client.storage.from('media').getPublicUrl(storagePath);

      debugPrint('🟩 [Upload] Public URL generated');
      debugPrint('🟩 [Upload] URL: $publicUrl');

      return publicUrl;
    } catch (e, st) {
      debugPrint('🟥 [Upload] FAILED');
      debugPrint('🟥 Error: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  Future<void> deleteGroupMessage(String messageId) async {
    try {
      await _client
          .from('messages')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', messageId);
    } catch (e, stack) {
      debugPrint('🟥 [GroupChatRepo] deleteGroupMessage ERROR: $e');
      debugPrint('🟥 [GroupChatRepo] STACKTRACE:\n$stack');
      rethrow;
    }
  }

  Future<void> deleteGroupMessageForMe(String messageId) async {
    await _client.rpc(
      'delete_message_for_me',
      params: {'p_message_id': messageId},
    );
  }

  Future<void> toggleSaveMessage({
    required GroupMessage message,
    String? source,
    String? sourceType,
  }) async {
    try {
      final userId = _client.auth.currentUser!.id;

      final existing = await _client
          .from('saved_messages')
          .select()
          .eq('user_id', userId)
          .eq('message_id', message.id)
          .maybeSingle();

      if (existing != null) {
        await _client.from('saved_messages').delete().eq('id', existing['id']);
        debugPrint('⭐ Unsaved message: ${message.id}');
      } else {
        await _client.from('saved_messages').insert({
          'user_id': userId,
          'message_id': message.id,
          'sender_id': message.senderId,
          'content': message.text,
          'media_url': message.imagePath,
          'media_type': message.mediaType,
          'source': source,
          'source_type': sourceType,
          'saved_at': DateTime.now().toIso8601String(),
        });
        debugPrint('⭐ Saved message: ${message.id}');
      }
    } catch (e, stack) {
      debugPrint('🟥 [GroupChatRepo] toggleSaveMessage ERROR: $e');
      debugPrint('🟥 [GroupChatRepo] STACKTRACE:\n$stack');
      rethrow;
    }
  }

  Future<String> getOrCreateConversation(String otherUserId) async {
    debugPrint('🟦 [Repo] getOrCreateConversation for $otherUserId');
    try {
      final response = await _client.rpc(
        'create_conversation',
        params: {
          'p_other_user_id': otherUserId,
        },
      );
      debugPrint('🟩 [Repo] create_conversation result: $response');
      
      final data = response as Map<String, dynamic>;
      return data['conversation_id'] as String;
    } catch (e) {
      debugPrint('🟥 [Repo] create_conversation failed: $e');
      rethrow;
    }
  }

 Future<void> forwardMessage({
  String? conversationId,
  String? circleId,
  required Map<String, dynamic> payload,
}) async {
  debugPrint('🟦 [Repo] Forwarding message to ${conversationId ?? circleId}');
  debugPrint('🟦 [Repo] Payload: $payload');

  final senderId = _client.auth.currentUser!.id;

  await _client.from('messages').insert({
    'sender_id': senderId,
    if (conversationId != null) 'conversation_id': conversationId,
    if (circleId != null) 'circle_id': circleId,
    ...payload,
  });

  debugPrint('🟩 [Repo] Forward insert success');
}


}
