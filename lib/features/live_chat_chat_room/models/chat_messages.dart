import 'package:flutter/material.dart';

final List<ChatMessage> defaultChatMessages = [];

final ValueNotifier<List<ChatMessage>> chatMessages =
    ValueNotifier<List<ChatMessage>>([]);

class ChatMessage {
  final String? id;
  final String? senderId;
  final bool isSender;
  final String? profileAsset;
  final String? name;
  final String text;
  final String time;
  final String? imageAsset;
  final String? imageFile;
  final bool isFriend;
  final DateTime? createdAt;
  final bool isLocal;
  final bool isStarred;
  final bool isReported;


  ChatMessage({
    this.id,
    this.senderId,
    required this.isSender,
    this.profileAsset,
    this.name,
    required this.text,
    required this.time,
    this.imageAsset,
    this.imageFile,
    this.isFriend = false,
    this.createdAt,
    this.isLocal = false,
    this.isStarred = false,
    this.isReported = false,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map, String currentUserId) {
    final senderId = map['sender_id'] as String?;
    final isSender = senderId == currentUserId;
    final content = map['content'] as String? ?? '';
    final createdAt = map['created_at'] as String?;
    final id = map['id']?.toString();
    final isStarred = map['is_starred'] == true;
    String time = '';
    if (createdAt != null) {
      final dateTime = DateTime.tryParse(createdAt);
      if (dateTime != null) {
        final localTime = dateTime.toLocal();
        final hour = localTime.hour > 12
            ? localTime.hour - 12
            : (localTime.hour == 0 ? 12 : localTime.hour);
        final period = localTime.hour >= 12 ? 'PM' : 'AM';
        final minute = localTime.minute.toString().padLeft(2, '0');
        time = '$hour:$minute $period';
      }
    }
    final isReported = map['is_reported'] == true;
    final mediaUrl = map['media_url'] as String?;

    return ChatMessage(
      id: id,
      senderId: senderId,
      isSender: isSender,
      text: content,
      time: time,
      profileAsset: isSender ? null : 'assets/images/Ellipse 1.png',
      name: isSender ? 'You' : 'User',
      imageFile: mediaUrl,
      isStarred: isStarred,
      isReported: isReported,
    );
  }

  ChatMessage copyWith({
    String? id,
    String? senderId,
    bool? isSender,
    String? profileAsset,
    String? name,
    String? text,
    String? time,
    String? imageAsset,
    String? imageFile,
    bool? isFriend,
    bool? isStarred,
    bool? isReported,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      isSender: isSender ?? this.isSender,
      profileAsset: profileAsset ?? this.profileAsset,
      name: name ?? this.name,
      text: text ?? this.text,
      time: time ?? this.time,
      imageAsset: imageAsset ?? this.imageAsset,
      imageFile: imageFile ?? this.imageFile,
      isFriend: isFriend ?? this.isFriend,
      isStarred: isStarred ?? this.isStarred,
      isReported: isReported ?? this.isReported, 
    );
  }
}
