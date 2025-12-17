import 'package:flutter/material.dart';
import 'package:senior_circle/core/constants/group_messages.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/message_input_field.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_app_bar.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_card.dart';
import 'package:senior_circle/features/my_circle_home/models/chat_model.dart';

class MyCircleGroupChatPage extends StatefulWidget {
  const MyCircleGroupChatPage({super.key, required this.chat});
  final Chat chat;

  @override
  State<MyCircleGroupChatPage> createState() => _MyCircleGroupChatPageState();
}

class _MyCircleGroupChatPageState extends State<MyCircleGroupChatPage> {
  // Create a local list from your constant data
  late List<GroupMessage> _messages = List.from(groupMessages);
@override
  void initState() {
    super.initState();
    // Initialize the list and force all threads to be closed
    _messages = groupMessages.map((msg) {
      msg.isThreadOpen = false; 
      // Also ensure the inline reply input is closed if you have that in the model
      return msg;
    }).toList();
  }
  void _handleSendMessage(String text) {
    setState(() {
      _messages.add(
        GroupMessage(
          senderName: "You",
          text: text,
          time: TimeOfDay.now().toString(), // You can use a DateFormat here later
          avatar: "assets/images/user_placeholder.png", 
          replies: [], id: '1', senderId: 'me-id',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: MyCircleChatroomAppBar(chat: widget.chat),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final currentMsg = _messages[index];
                bool isContinuation = false;
                if (index > 0) {
                  final previousMsg = _messages[index - 1];
                  isContinuation = previousMsg.senderName == currentMsg.senderName;
                }

                return GroupMessageCard(
                  grpmessage: currentMsg,
                  isContinuation: isContinuation,
                );
              },
            ),
          ),
          // Pass the function to your input field
          MessageInputField(onSend: _handleSendMessage),
        ],
      ),
    );
  }
}