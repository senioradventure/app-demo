import 'package:senior_circle/features/my_circle_chatroom/models/reaction_model.dart';

class GroupMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? avatar;
  final String? text;
  final String? imagePath;
  final String time;
  final List<Reaction> reactions;
  final List<GroupMessage> replies;
  final bool isThreadOpen;
  final bool isReplyInputOpen;

  const GroupMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.avatar,
    this.text,
    required this.time,
    this.imagePath,
    this.reactions = const [],
    this.replies = const [],
    this.isThreadOpen = false,
    this.isReplyInputOpen = false,
  });



  GroupMessage copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? avatar,
    String? text,
    String? imagePath,
    String? time,
    List<Reaction>? reactions,
    List<GroupMessage>? replies,
    bool? isThreadOpen,
    bool? isReplyInputOpen,
  }) {
    return GroupMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      avatar: avatar ?? this.avatar,
      text: text ?? this.text,
      imagePath: imagePath ?? this.imagePath,
      time: time ?? this.time,
      reactions: reactions ?? this.reactions,
      replies: replies ?? this.replies,
      isThreadOpen: isThreadOpen ?? this.isThreadOpen,
      isReplyInputOpen: isReplyInputOpen ?? this.isReplyInputOpen,
    );
  }

  factory GroupMessage.fromMap(Map<String, dynamic> map) {
    final reactionsRaw = Map<String, dynamic>.from(map['reactions'] ?? {});

    return GroupMessage(
      id: map['id'],
      senderId: map['senderId'],
      senderName: map['senderName'],
      avatar: map['avatar'],
      text: map['text'],
      time: map['time'],
      imagePath: map['imagePath'],
      isThreadOpen: map['isThreadOpen'] ?? false,
      isReplyInputOpen: map['isReplyInputOpen'] ?? false,
      replies: (map['replies'] as List? ?? [])
          .map((e) => GroupMessage.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      reactions: reactionsRaw.entries.map((entry) {
        return Reaction(
          emoji: entry.key,
          userIds: List<String>.from(entry.value),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'avatar': avatar,
      'text': text,
      'imagePath': imagePath,
      'time': time,
      'isThreadOpen': isThreadOpen,
      'isReplyInputOpen': isReplyInputOpen,
      'reactions': {
      for (final reaction in reactions) reaction.emoji: reaction.userIds,
    },
      'replies': replies.map((reply) => reply.toMap()).toList(),
    };
  }
}
