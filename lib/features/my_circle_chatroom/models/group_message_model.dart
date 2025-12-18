
import 'package:senior_circle/features/my_circle_chatroom/models/reaction_model.dart';

class GroupMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String? avatar;
  final String text;
  final String time;
  final List<Reaction> reactions;
  final List<GroupMessage> replies;
  bool isThreadOpen;

  GroupMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.avatar,
    required this.text,
    required this.time,
    this.reactions = const [],
    this.replies = const [],
    this.isThreadOpen = false,
  });


  factory GroupMessage.fromMap(Map<String, dynamic> map) {
    return GroupMessage(
      id: map['id']?.toString() ?? '',
      senderId: map['senderId']?.toString() ?? '',
      senderName: map['senderName'] ?? '',
      avatar: map['avatar'],
      text: map['text'] ?? '',
      time: map['time'] ?? '',
      isThreadOpen: map['isThreadOpen'] ?? false,
      reactions: (map['reactions'] as List? ?? [])
          .map((r) => Reaction.fromMap(r))
          .toList(),
      replies: (map['replies'] as List? ?? [])
          .map((reply) => GroupMessage.fromMap(reply))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'senderName': senderName,
      'avatar': avatar,
      'text': text,
      'time': time,
      'isThreadOpen': isThreadOpen,
      'reactions': reactions.map((r) => r.toMap()).toList(),
      'replies': replies.map((reply) => reply.toMap()).toList(),
    };
  }
}

