import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_individual_message_card.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_app_bar.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_grp_message_card.dart';
import 'package:senior_circle/features/my_circle_home/models/chat_model.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';

class MyCircleChatroomPage extends StatefulWidget {
  const MyCircleChatroomPage({super.key, required this.chat});

  final Chat chat;

  @override
  State<MyCircleChatroomPage> createState() => _MyCircleChatroomPageState();
}

class _MyCircleChatroomPageState extends State<MyCircleChatroomPage> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.chat.isGroup ? Colors.white : null,
      appBar: null,
      body: Container(
        decoration: widget.chat.isGroup
            ? null
            : BoxDecoration(gradient: AppColors.chatGradient),
        child: Column(
          children: [
            MyCircleChatroomAppBar(chat: widget.chat),
            if (widget.chat.isGroup)
              Expanded(
                child: ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return GroupMessageCard(grpmessage: messages[index]);
                  },
                ),
              ),
            if (!widget.chat.isGroup)
              const Expanded(child: MyCircleIndividualMessageCard()),
            _buildMessageInputField(),
          ],
        ),
      ),
    );
  }


  // Message Input Field

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: AppColors.lightGray,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add, color: AppColors.buttonBlue, size: 28),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Type a message",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {},
            child: SvgPicture.asset('assets/icons/mic_button.svg'),
          ),
        ],
      ),
    );
  }
}
