import 'package:flutter/material.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_grp_message_card.dart';

class MessageReplies extends StatelessWidget {
  final List<GroupMessage> replies;

  const MessageReplies({super.key, required this.replies});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: replies
          .map((reply) => GroupMessageCard(grpmessage: reply, isReply: true))
          .toList(),
    );
  }
}
