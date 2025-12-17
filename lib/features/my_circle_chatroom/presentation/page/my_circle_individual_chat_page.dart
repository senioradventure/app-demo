import 'package:flutter/material.dart';
import 'package:senior_circle/core/constants/inividual_messages.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_individual_message_card.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/message_input_field.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_app_bar.dart';
import 'package:senior_circle/features/my_circle_home/models/chat_model.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';


class MyCircleIndividualChatPage extends StatelessWidget {
  const MyCircleIndividualChatPage({super.key, required this.chat});

  final Chat chat;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: null,
      appBar: MyCircleChatroomAppBar(chat: chat),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.chatGradient),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: individualMessages.length,
                itemBuilder: (context, index) {
                  return IndividualMessageCard(message:individualMessages[index]);
                },
              ),
            ),
            MessageInputField(),
          ],
        ),
      ),
    );
  }
}
