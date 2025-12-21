
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
  bool isThreadOpen;

  GroupMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.avatar,
    this.text,
    required this.time,
    this.reactions = const [],
    this.replies = const [],
    this.isThreadOpen = false, 
    this.imagePath,
  });


  factory GroupMessage.fromMap(Map<String, dynamic> map) {
  final reactionsRaw =
      Map<String, dynamic>.from(map['reactions'] ?? {});

  return GroupMessage(
    id: map['id'],
    senderId: map['senderId'],
    senderName: map['senderName'],
    avatar: map['avatar'],
    text: map['text'],
    time: map['time'],
    imagePath: map['imagePath'],
    replies: (map['replies'] as List? ?? [])
        .map((e) => GroupMessage.fromMap(
              Map<String, dynamic>.from(e),
            ))
        .toList(),
    reactions: reactionsRaw.entries.map((entry) {
      final userIds = List<String>.from(entry.value);
      return Reaction(
        emoji: entry.key,
        userIds: userIds,
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
      'imagePath' : imagePath,
      'time': time,
      'isThreadOpen': isThreadOpen,
      'reactions': reactions.map((r) => r.toMap()).toList(),
      'replies': replies.map((reply) => reply.toMap()).toList(),
    };
  }
}

