import 'package:flutter/material.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/message_input_field.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_app_bar.dart';
import 'package:senior_circle/features/my_circle_home/models/chat_model.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';
import 'package:senior_circle/theme/texttheme/text_theme.dart';

class MyCircleIndividualChatPage extends StatelessWidget {
  MyCircleIndividualChatPage({super.key, required this.chat});

  final Chat chat;
  final List<Message> message = [
    Message(
      id: '1',
      sender: 'Alice',
      text: 'Good morning. How are you?',
      time: '10:00 AM',
    ),
    Message(
      id: '2',
      sender: 'You',
      text: 'Hi Alice! Welcome to the chat',
      time: '10:02 AM',
    ),
    Message(
      id: '3',
      sender: 'You',
      text: 'Have a great day!',
      time: '10:05 AM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: null,
      appBar: null,
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.chatGradient),
        child: Column(
          children: [
            MyCircleChatroomAppBar(chat: chat),
            Expanded(
              child: ListView.builder(
                itemCount: message.length,
                itemBuilder: (context, index) {
                  return _buildMessage(message[index]);
                },
              ),
            ),
            MessageInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(Message msg) {
    final isMe = msg.sender == 'You';

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isMe ? AppColors.lightBlue : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: const BoxConstraints(
            maxWidth: 280, // limit width like WhatsApp
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // time always left
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msg.text, style: AppTextTheme.lightTextTheme.bodyMedium),
              const SizedBox(height: 4),
              Text(
                msg.time,
                style: AppTextTheme.lightTextTheme.labelSmall?.copyWith(
                  color: AppColors.textGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
