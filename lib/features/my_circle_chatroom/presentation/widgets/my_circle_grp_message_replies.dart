import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_card.dart';

class MessageReplies extends StatelessWidget {
  final List<GroupMessage> replies;

  const MessageReplies({super.key, required this.replies});

  @override
  Widget build(BuildContext context) {
    if (replies.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        const Divider(color: AppColors.borderColor, thickness: 1, height: 0),
        Padding(
          padding: EdgeInsetsGeometry.only(
            left: 33,
            right: 12,
            bottom: 8,
            top: 8,
          ),
          child: Column(
            children: List.generate(replies.length, (index) {
              final currentReply = replies[index];
              bool isContinuation = false;
              if (index > 0) {
                isContinuation =
                    replies[index - 1].senderName == currentReply.senderName;
              }
              return GroupMessageCard(
                key: ValueKey(currentReply.id),
                grpmessage: currentReply,
                isReply: true,
                isContinuation: isContinuation,
              );
            }),
          ),
        ),
      ],
    );
  }
}
