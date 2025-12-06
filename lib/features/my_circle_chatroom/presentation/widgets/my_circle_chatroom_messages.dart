
import 'package:flutter/material.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/message_actions.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/message_replies.dart';import 'package:senior_circle/features/my_circle_chatroom/models/message_model.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';
import 'package:senior_circle/theme/texttheme/text_theme.dart';


final List<Message> messages = [
  Message(
    id: '1',
    sender: 'Alice',
    avatar: 'https://i.pravatar.cc/150?img=1',
    text: 'Hello everyone!',
    time: '10:00 AM',
    replies: [
      Message(
        id: '1-1',
        sender: 'Bob',
        avatar: 'https://i.pravatar.cc/150?img=2',
        text: 'Hi Alice!',
        time: '10:03 AM',
      ),
      Message(
        id: '1-1',
        sender: 'clara',
        avatar: 'https://i.pravatar.cc/150?img=2',
        text: 'Hi Alice!',
        time: '10:03 AM',
      ),
    ],
    reactions: [Reaction('👍', 3), Reaction('❤️', 2)],
  ),
  Message(
    id: '2',
    sender: 'Bob',
    avatar: 'https://i.pravatar.cc/150?img=2',
    text: 'Hi Alice!',
    time: '10:02 AM',
    reactions: [Reaction('😊', 1)],
  ),
  Message(
    id: '3',
    sender: 'Charlie',
    avatar: 'https://i.pravatar.cc/150?img=3',
    text: 'Good morning!',
    time: '10:05 AM',
  ),
];


class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    final message = widget.message;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(message.avatar),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(message),
                const SizedBox(height: 4),
                Text(message.text,
                    style: AppTextTheme.lightTextTheme.bodyMedium),
                const SizedBox(height: 6),

                MessageActions(
                  onReplyTap: () {},
                ),

                if (message.replies.isNotEmpty)
                  _buildReplyButton(message),

                if (message.isThreadOpen)
                  MessageReplies(replies: message.replies),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(Message message) => Row(
    children: [
      Text(message.sender, style: AppTextTheme.lightTextTheme.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
      )),
      const SizedBox(width: 14),
      Text(message.time, style: AppTextTheme.lightTextTheme.labelSmall?.copyWith(
       fontWeight: FontWeight.w700),
      ),
    ],
  );

  Widget _buildReplyButton(Message message) => Center(
    child: TextButton.icon(
      onPressed: () => setState(() => message.isThreadOpen = !message.isThreadOpen),
      label: Text(
        "${message.replies.length} Replies",
        style: TextStyle(
          color: message.isThreadOpen ? AppColors.textDarkGray : AppColors.buttonBlue,
        ),
      ),
      icon: Icon(
        message.isThreadOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        color: message.isThreadOpen ? AppColors.textDarkGray : AppColors.buttonBlue,
        size: 24,
      ),
      iconAlignment: IconAlignment.end,
    ),
  );
}
