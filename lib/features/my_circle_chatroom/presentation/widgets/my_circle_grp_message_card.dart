import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_actions.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_replies.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';

class GroupMessageCard extends StatefulWidget {
  final GroupMessage grpmessage;
  final bool isReply;

  const GroupMessageCard({
    super.key,
    required this.grpmessage,
    this.isReply = false,
  });

  @override
  State<GroupMessageCard> createState() => _GroupMessageCardState();
}

class _GroupMessageCardState extends State<GroupMessageCard> {
  @override
  Widget build(BuildContext context) {
    final grpmessage = widget.grpmessage;

    return Container(
      margin: EdgeInsets.only(
        top: widget.isReply ? 0 : 4,
        bottom: widget.isReply ? 0 : 4,
      ),
      decoration: BoxDecoration(
        color: grpmessage.senderName.toLowerCase() == 'you'
            ? const Color(0xFFF9EFDB)
            : AppColors.white,
        border: widget.isReply
            ? null
            : Border.all(color: AppColors.borderColor, width: 2),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(grpmessage.avatar ?? ''),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(grpmessage),
                  const SizedBox(height: 4),
                  Text(
                    grpmessage.text,
                    style: AppTextTheme.lightTextTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),

                  MessageActions(onReplyTap: () {}, isReply: widget.isReply),

                  if (grpmessage.replies.isNotEmpty)
                    _buildReplyButton(grpmessage),

                  if (grpmessage.isThreadOpen)
                    MessageReplies(replies: grpmessage.replies),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(GroupMessage grpmessage) => Row(
    children: [
      Text(
        grpmessage.senderName,
        style: AppTextTheme.lightTextTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(width: 14),
      Text(
        grpmessage.time,
        style: AppTextTheme.lightTextTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );

  Widget _buildReplyButton(GroupMessage grpmessage) => Center(
    child: TextButton.icon(
      onPressed: () =>
          setState(() => grpmessage.isThreadOpen = !grpmessage.isThreadOpen),
      label: Text(
        "${grpmessage.replies.length} Replies",
        style: TextStyle(
          color: grpmessage.isThreadOpen
              ? AppColors.textDarkGray
              : AppColors.buttonBlue,
        ),
      ),
      icon: Icon(
        grpmessage.isThreadOpen
            ? Icons.keyboard_arrow_up
            : Icons.keyboard_arrow_down,
        color: grpmessage.isThreadOpen
            ? AppColors.textDarkGray
            : AppColors.buttonBlue,
        size: 24,
      ),
      iconAlignment: IconAlignment.end,
    ),
  );
}
