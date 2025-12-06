import 'package:flutter/material.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_messages.dart';

class MessageReplies extends StatelessWidget {
  final List<Message> replies;

  const MessageReplies({super.key, required this.replies});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: replies
          .map((reply) => MessageCard(message: reply, isReply: true))
          .toList(),
    );
  }
}
