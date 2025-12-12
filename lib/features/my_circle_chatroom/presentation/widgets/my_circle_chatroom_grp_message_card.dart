import 'package:flutter/material.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/grp_message_actions.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/grp_message_replies.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';
import 'package:senior_circle/theme/texttheme/text_theme.dart';

final List<GroupMessage> messages = [
  GroupMessage(
    id: '1',
    senderId: 'Alice-id',
    senderName: 'Alice',
    avatar: 'https://i.pravatar.cc/150?img=1',
    text: 'Hello everyone!',
    time: '10:00 AM',
    replies: [
      GroupMessage(
        id: '1-1',
        senderId: 'me-id',
        senderName: 'You',
        avatar: 'https://i.pravatar.cc/150?img=2',
        text: 'Hi Alice!',
        time: '10:03 AM',
      ),
      GroupMessage(
        id: '1-2',
        senderId: 'clara-id',
        senderName: 'Clara',
        avatar: 'https://i.pravatar.cc/150?img=2',
        text: 'Hi Alice!',
        time: '10:03 AM',
      ),
    ],
    reactions: [Reaction('👍', 3), Reaction('❤️', 2)],
  ),
  GroupMessage(
    id: '2',
    senderId: 'me-id',
    senderName: 'You',
    avatar: 'https://i.pravatar.cc/150?img=2',
    text: 'Hi Alice!',
    time: '10:02 AM',
    reactions: [Reaction('😊', 1)],
  ),
  GroupMessage(
    id: '3',
    senderId: 'charlie-id',
    senderName: 'Charlie',
    avatar: 'https://i.pravatar.cc/150?img=3',
    text: 'Good morning!',
    time: '10:05 AM',
  ),
];

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
      color: grpmessage.senderName.toLowerCase() == 'you'
          ? const Color(0xFFF9EFDB)
          : AppColors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
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
