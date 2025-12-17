import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/message_input_field.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_app_bar.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_grp_message_card.dart';
import 'package:senior_circle/features/my_circle_home/models/chat_model.dart';

class MyCircleGroupChatPage extends StatelessWidget {
  const MyCircleGroupChatPage({super.key, required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: null,
      body: Column(
        children: [
          MyCircleChatroomAppBar(chat: chat),

          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return GroupMessageCard(grpmessage: messages[index]);
              },
            ),
          ),
          MessageInputField(),
        ],
      ),
    );
  }
}
