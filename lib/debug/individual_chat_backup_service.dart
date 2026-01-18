import 'package:flutter/material.dart';
import 'package:senior_circle/core/local_db/app_database.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IndividualChatBackupService {
  final AppDatabase _database;
  final SupabaseClient _supabase;

  IndividualChatBackupService({
    required AppDatabase database,
    SupabaseClient? supabase,
  }) : _database = database,
       _supabase = supabase ?? Supabase.instance.client;

  /// Backup all individual chat messages to Supabase
  /// Only backs up messages sent by the current user (respects RLS policy)
  Future<Map<String, dynamic>> backupMessages() async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;

      if (currentUserId == null) {
        return {
          'success': false,
          'message': 'User not authenticated',
          'count': 0,
        };
      }

      // Fetch all messages from local database
      final allMessages = await _database.individualMessagesDao
          .getAllMessages();

      if (allMessages.isEmpty) {
        return {
          'success': true,
          'message': 'No messages to backup',
          'count': 0,
        };
      }

      // Filter to only include messages sent by current user (RLS requirement)
      final userMessages = allMessages
          .where((msg) => msg.senderId == currentUserId)
          .toList();

      if (userMessages.isEmpty) {
        return {
          'success': true,
          'message': 'No messages from current user to backup',
          'count': 0,
          'skipped': allMessages.length,
        };
      }

      // Convert to Supabase format
      final messagesData = userMessages.map((msg) {
        // Build the base message data
        final data = {
          'id': msg.id,
          'sender_id': msg.senderId,
          'content': msg.content,
          'media_type': msg.mediaType,
          'conversation_id': msg.conversationId,
          'created_at': msg.createdAt.toIso8601String(),
          // updated_at is NOT NULL in Supabase, use created_at if null
          'updated_at': (msg.updatedAt ?? msg.createdAt).toIso8601String(),
        };

        // Add optional fields only if they have values
        if (msg.mediaUrl != null) {
          data['media_url'] = msg.mediaUrl!;
        }
        if (msg.replyToMessageId != null) {
          data['reply_to_message_id'] = msg.replyToMessageId!;
        }
        if (msg.forwardedFromMessageId != null) {
          data['forwarded_from_message_id'] = msg.forwardedFromMessageId!;
        }
        if (msg.expiresAt != null) {
          data['expires_at'] = msg.expiresAt!.toIso8601String();
        }
        if (msg.deletedAt != null) {
          data['deleted_at'] = msg.deletedAt!.toIso8601String();
        }

        return data;
      }).toList();

      // Upsert to Supabase
      await _supabase.from('messages').upsert(messagesData, onConflict: 'id');

      final skippedCount = allMessages.length - userMessages.length;
      final message = skippedCount > 0
          ? 'Backed up ${userMessages.length} messages (skipped $skippedCount from other users)'
          : 'Successfully backed up ${userMessages.length} messages';

      debugPrint('✅ $message');

      return {
        'success': true,
        'message': message,
        'count': userMessages.length,
        'skipped': skippedCount,
      };
    } catch (e) {
      debugPrint('❌ Error backing up messages: $e');
      return {'success': false, 'message': 'Error: $e', 'count': 0};
    }
  }

  /// Backup all message reactions to Supabase
  /// Only backs up reactions created by the current user (respects RLS policy)
  Future<Map<String, dynamic>> backupReactions() async {
    try {
      final currentUserId = _supabase.auth.currentUser?.id;

      if (currentUserId == null) {
        return {
          'success': false,
          'message': 'User not authenticated',
          'count': 0,
        };
      }

      // Fetch all reactions from local database
      final allReactions = await _database.messageReactionsDao
          .getAllReactions();

      if (allReactions.isEmpty) {
        return {
          'success': true,
          'message': 'No reactions to backup',
          'count': 0,
        };
      }

      // Filter to only include reactions by current user (RLS requirement)
      final userReactions = allReactions
          .where((reaction) => reaction.userId == currentUserId)
          .toList();

      if (userReactions.isEmpty) {
        return {
          'success': true,
          'message': 'No reactions from current user to backup',
          'count': 0,
          'skipped': allReactions.length,
        };
      }

      // Get all messages sent by current user to validate reactions
      final userMessages = await _database.individualMessagesDao
          .getAllMessages();
      final userMessageIds = userMessages
          .where((msg) => msg.senderId == currentUserId)
          .map((msg) => msg.id)
          .toSet();

      // Filter reactions to only include those for messages sent by current user
      // This satisfies the RLS policy: message must exist in Supabase
      final validReactions = userReactions
          .where((reaction) => userMessageIds.contains(reaction.messageId))
          .toList();

      if (validReactions.isEmpty) {
        return {
          'success': true,
          'message': 'No reactions for your messages to backup',
          'count': 0,
          'skipped': userReactions.length,
        };
      }

      // Convert to Supabase format
      final reactionsData = validReactions.map((reaction) {
        return {
          'id': reaction.id,
          'message_id': reaction.messageId,
          'user_id': reaction.userId,
          'reaction': reaction.reaction,
          'created_at': reaction.createdAt.toIso8601String(),
        };
      }).toList();

      // Upsert to Supabase
      await _supabase
          .from('message_reactions')
          .upsert(reactionsData, onConflict: 'id');

      final skippedCount = allReactions.length - validReactions.length;
      final message = skippedCount > 0
          ? 'Backed up ${validReactions.length} reactions (skipped $skippedCount)'
          : 'Successfully backed up ${validReactions.length} reactions';

      debugPrint('✅ $message');

      return {
        'success': true,
        'message': message,
        'count': validReactions.length,
        'skipped': skippedCount,
      };
    } catch (e) {
      debugPrint('❌ Error backing up reactions: $e');
      return {'success': false, 'message': 'Error: $e', 'count': 0};
    }
  }

  /// Backup both messages and reactions
  Future<Map<String, dynamic>> backupAll() async {
    final messagesResult = await backupMessages();
    final reactionsResult = await backupReactions();

    final totalCount =
        (messagesResult['count'] as int) + (reactionsResult['count'] as int);
    final allSuccess =
        (messagesResult['success'] as bool) &&
        (reactionsResult['success'] as bool);

    return {
      'success': allSuccess,
      'message': allSuccess
          ? 'Backup completed: ${messagesResult['count']} messages, ${reactionsResult['count']} reactions'
          : 'Backup partially failed',
      'messagesCount': messagesResult['count'],
      'reactionsCount': reactionsResult['count'],
      'totalCount': totalCount,
      'messagesResult': messagesResult,
      'reactionsResult': reactionsResult,
    };
  }
}
