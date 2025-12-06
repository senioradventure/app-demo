import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/message_model.dart';
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
                Row(
                  children: [
                    Text(
                      message.sender,
                      style: AppTextTheme.lightTextTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      message.time,
                      style: AppTextTheme.lightTextTheme.labelSmall?.copyWith(
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message.text,
                  style: AppTextTheme.lightTextTheme.bodyMedium,
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.textLightGray),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: SvgPicture.asset('assets/icons/like_button.svg'),
                      ),
                    ),

                    IconButton(
                      icon: const Icon(Icons.add_circle),
                      onPressed: () {},
                      iconSize: 32,
                    ),
                    Spacer(),
                    TextButton.icon(
                      icon: SvgPicture.asset('assets/icons/reply_icon.svg'),
                      onPressed: () {},
                      label: Text(
                        "Reply",
                        style: AppTextTheme.lightTextTheme.labelMedium
                            ?.copyWith(color: AppColors.textDarkGray),
                      ),
                    ),
                  ],
                ),

                if (message.replies.isNotEmpty)
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          message.isThreadOpen = !message.isThreadOpen;
                        });
                      },
                      label: Text(
                        message.isThreadOpen
                            ? "${message.replies.length} Replies"
                            : "${message.replies.length} Replies",
                        style: message.isThreadOpen
                            ? AppTextTheme.lightTextTheme.labelMedium?.copyWith(
                                color: AppColors.textGray,
                              )
                            : AppTextTheme.lightTextTheme.labelMedium?.copyWith(
                                color: AppColors.buttonBlue,
                              ),
                      ),
                      iconAlignment: IconAlignment.end,
                      icon: Icon(
                        message.isThreadOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,

                        color: message.isThreadOpen
                            ? AppColors.textGray
                            : AppColors.buttonBlue,
                        size: 24,
                      ),
                    ),
                  ),
                if (message.isThreadOpen)
                  Padding(
                    padding: const EdgeInsets.only(left: 0, top: 6),
                    child: Column(
                      children: message.replies
                          .map((reply) => MessageCard(message: reply))
                          .toList(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
