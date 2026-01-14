import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:senior_circle/core/database/app_database.dart';
import 'package:senior_circle/features/circle_chat/models/circle_chat_message_model.dart';
import 'package:senior_circle/features/circle_chat/models/reaction_model.dart';

class CircleMessageConverter {
  /// Convert CircleChatMessage to Drift Companion for insert/update
  static CircleMessagesCompanion toCompanion(CircleChatMessage message, String circleId) {
    // Serialize reactions to JSON
    final reactionsMap = <String, List<String>>{};
    for (final reaction in message.reactions) {
      reactionsMap[reaction.emoji] = reaction.userIds;
    }
    
    // Serialize replies to JSON (simplified - just IDs)
    final repliesIds = message.replies.map((r) => r.id).toList();
    
    return CircleMessagesCompanion(
      id: Value(message.id),
      circleId: Value(circleId),
      senderId: Value(message.senderId),
      senderName: Value(message.senderName),
      mediaType: Value(message.mediaType),
      avatar: Value(message.avatar),
      content: Value(message.text),
      mediaUrl: Value(message.imagePath),
      createdAt: Value(DateTime.tryParse(message.time) ?? DateTime.now()),
      replyToMessageId: Value(message.replyToMessageId),
      isStarred: Value(message.isStarred),
      reactionsJson: Value(jsonEncode(reactionsMap)),
      repliesJson: Value(jsonEncode(repliesIds)),
    );
  }

  /// Convert Drift CircleMessage to CircleChatMessage
  static CircleChatMessage fromDrift(CircleMessage message) {
    // Deserialize reactions from JSON
    final reactionsMap = jsonDecode(message.reactionsJson) as Map<String, dynamic>;
    final reactions = reactionsMap.entries.map((entry) {
      return Reaction(
        emoji: entry.key,
        userIds: List<String>.from(entry.value),
      );
    }).toList();
    
    return CircleChatMessage(
      id: message.id,
      senderId: message.senderId,
      senderName: message.senderName,
      mediaType: message.mediaType,
      avatar: message.avatar,
      text: message.content,
      imagePath: message.mediaUrl,
      time: message.createdAt.toIso8601String(),
      reactions: reactions,
      replies: const [], // Replies loaded separately
      replyToMessageId: message.replyToMessageId,
      isStarred: message.isStarred,
    );
  }

  /// Convert list of Drift messages to CircleChatMessage models
  static List<CircleChatMessage> fromDriftList(List<CircleMessage> messages) {
    return messages.map((m) => fromDrift(m)).toList();
  }

  /// Convert list of CircleChatMessage to Drift Companions
  static List<CircleMessagesCompanion> toCompanionList(List<CircleChatMessage> messages, String circleId) {
    return messages.map((m) => toCompanion(m, circleId)).toList();
  }
}
