import 'package:flutter/material.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_card.dart';

class MessageReplies extends StatelessWidget {
  final List<GroupMessage> replies;

  const MessageReplies({super.key, required this.replies});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(replies.length, (index) {
        final currentReply = replies[index];

        bool isContinuation = false;
        if (index > 0) {
          isContinuation = replies[index - 1].senderName == currentReply.senderName;
        }

        return GroupMessageCard(
          grpmessage: currentReply,
          isReply: true,
          isContinuation: isContinuation,
        );
      }),
    );
  }
}