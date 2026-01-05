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
    debugPrint('🟦 [GroupChatRepo] Fetching messages for circleId: $circleId');

    try {
      final messageRows = await _client
          .from('messages')
          .select('''
      id,
      sender_id,
      content,
      media_url,
      media_type,
      reply_to_message_id,
      created_at,
      profiles!messages_sender_id_fkey (
        id,
        full_name,
        avatar_url
      )
    ''')
          .eq('circle_id', circleId)
          .filter('deleted_at', 'is', null)
          .order('created_at');

      debugPrint('🟩 [GroupChatRepo] Messages fetched: ${messageRows.length}');

      if (messageRows.isEmpty) {
        debugPrint('🟨 [GroupChatRepo] No messages found');
        return [];
      }

      /// 2️⃣ Collect message IDs
      final messageIds = messageRows
          .map<String>((m) => m['id'] as String)
          .toList();

      debugPrint(
        '🟩 [GroupChatRepo] Collecting reactions for ${messageIds.length} messages',
      );

      /// 3️⃣ Fetch reactions
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

      debugPrint(
        '🟩 [GroupChatRepo] Reactions grouped for ${reactionsByMessage.keys.length} messages',
      );

      final Map<String, List<GroupMessage>> repliesByParent = {};
      final Map<String, GroupMessage> allMessages = {};

      for (final row in messageRows) {
        final id = row['id'] as String;
        final replyTo = row['reply_to_message_id'] as String?;

        final reactions = ReactionMapper.aggregate(
          reactionsByMessage[id] ?? [],
        );
        final mediaType = row['media_type'];
        final message = GroupMessage(
          id: id,
          senderId: row['sender_id'] ?? '',
          senderName: row['profiles']?['full_name'] ?? 'Unknown',
          avatar: row['profiles']?['avatar_url'],
          text: mediaType == 'text' ? row['content'] : row['content'],
          imagePath: mediaType == 'image' ? row['media_url'] : null,
          time: row['created_at'] as String,
          reactions: reactions,
          replies: const [],
        );

        allMessages[id] = message;

        if (replyTo != null) {
          repliesByParent.putIfAbsent(replyTo, () => []);
          repliesByParent[replyTo]!.add(message);
        }
      }

      debugPrint(
        '🟩 [GroupChatRepo] Total messages: ${allMessages.length}, '
        'Replies: ${repliesByParent.values.fold<int>(0, (sum, l) => sum + l.length)}',
      );

      final List<GroupMessage> parentMessages = [];

      for (final message in allMessages.values) {
        final updated = message.copyWith(
          replies: (repliesByParent[message.id] ?? []).reversed.toList(),
        );

        if (!repliesByParent.values.any(
          (list) => list.any((r) => r.id == message.id),
        )) {
          parentMessages.add(updated);
        }
      }

      debugPrint(
        '🟦 [GroupChatRepo] Final parent messages count: ${parentMessages.length}',
      );

      return parentMessages;
    } catch (e, stack) {
      debugPrint('🟥 [GroupChatRepo] ERROR: $e');
      debugPrint('🟥 [GroupChatRepo] STACKTRACE:\n$stack');
      rethrow;
    }
  }

  Future<GroupMessage> sendGroupMessage({
    required String circleId,
    required String content,
    String? mediaUrl,
    String mediaType = 'text',
    String? replyToMessageId,
  }) async {
    final senderId = _client.auth.currentUser!.id;

    // 1. Insert and select with profile data
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

    debugPrint('🟩 [GroupChatRepo] Group message inserted and returned');

    // 2. Convert to GroupMessage
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
    final existing = await _client
        .from('message_reactions')
        .select()
        .eq('message_id', messageId)
        .eq('user_id', userId)
        .eq('reaction', emoji)
        .maybeSingle();

    if (existing != null) {
      await _client.from('message_reactions').delete().eq('id', existing['id']);
    } else {
      await _client.from('message_reactions').insert({
        'message_id': messageId,
        'user_id': userId,
        'reaction': emoji,
      });
    }
  }

  Future<void> sendGroupReply({
    required String circleId,
    required String parentMessageId,
    required String content,
  }) async {
    await Supabase.instance.client.from('messages').insert({
      'circle_id': circleId,
      'reply_to_message_id': parentMessageId,
      'content': content,
      'media_type': 'text',
    });
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
}
