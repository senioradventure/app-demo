import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:senior_circle/core/database/daos/circle_messages_dao.dart';
import 'package:senior_circle/core/database/converters/circle_message_converter.dart';
import 'package:senior_circle/features/circle_chat/models/circle_chat_message_model.dart';
import 'package:senior_circle/core/services/circle_media_storage_service.dart';

class CircleMessagesLocalRepository {
  final CircleMessagesDao _messagesDao;
  final CircleMediaStorageService _mediaStorage;

  CircleMessagesLocalRepository({
    required CircleMessagesDao messagesDao,
    CircleMediaStorageService? mediaStorage,
  })  : _messagesDao = messagesDao,
        _mediaStorage = mediaStorage ?? CircleMediaStorageService();

  /// Fetch messages from local database for a specific circle
  Future<List<CircleChatMessage>> fetchMessages(String circleId) async {
    debugPrint('🟦 [LocalRepo] Loading messages from local DB for circle $circleId');
    final driftMessages = await _messagesDao.getMessagesByCircle(circleId);
    final messages = CircleMessageConverter.fromDriftList(driftMessages);
    
    // Build message tree (attach replies to parent messages)
    return _buildMessageTree(messages);
  }

  /// Save messages to local database
  Future<void> saveMessages(
    List<CircleChatMessage> messages,
    String circleId,
  ) async {
    debugPrint('🟦 [LocalRepo] Syncing ${messages.length} messages to local DB');
    final companions = CircleMessageConverter.toCompanionList(messages, circleId);
    await _messagesDao.upsertMessages(companions);
    debugPrint('🟩 [LocalRepo] Local DB sync complete');
  }

  /// Attaches reply messages to their parent messages
  List<CircleChatMessage> _buildMessageTree(List<CircleChatMessage> messages) {
    final Map<String, List<CircleChatMessage>> repliesMap = {};
    
    // Group replies by parent message ID
    for (var m in messages) {
      if (m.replyToMessageId != null) {
        repliesMap.putIfAbsent(m.replyToMessageId!, () => []).add(m);
      }
    }
    
    // Return only top-level messages with their replies attached
    return messages
        .where((m) => m.replyToMessageId == null)
        .map((m) => m.copyWith(replies: (repliesMap[m.id] ?? []).reversed.toList()))
        .toList();
  }

  // ==================== Media File Storage ====================

  /// Save image file locally
  Future<File> saveImageLocally(File file) async {
    debugPrint('🟦 [LocalRepo] Saving image to local storage');
    return await _mediaStorage.saveMediaLocally(file, 'images');
  }

  /// Save file (PDF, doc, etc.) locally
  Future<File> saveFileLocally(File file) async {
    debugPrint('🟦 [LocalRepo] Saving file to local storage');
    return await _mediaStorage.saveMediaLocally(file, 'files');
  }

  /// Save audio file locally
  Future<File> saveAudioLocally(File file) async {
    debugPrint('🟦 [LocalRepo] Saving audio to local storage');
    return await _mediaStorage.saveMediaLocally(file, 'voice');
  }
}
