import 'package:flutter/material.dart';
import 'package:senior_circle/core/constants/group_messages.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/message_input_field.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_app_bar.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_card.dart';
import 'package:senior_circle/features/my_circle_home/models/chat_model.dart';

class MyCircleGroupChatPage extends StatefulWidget {
  const MyCircleGroupChatPage({super.key, required this.chat,required this.isAdmin });
  final Chat chat;
  final bool isAdmin;

  @override
  State<MyCircleGroupChatPage> createState() => _MyCircleGroupChatPageState();
}

class _MyCircleGroupChatPageState extends State<MyCircleGroupChatPage> {
  late List<GroupMessage> _messages;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages = groupMessages.map((msg) => msg).toList();
  }

  void _handleSendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        GroupMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(), 
          senderId: 'user_123',
          senderName: "You",
          text: text,
          time: TimeOfDay.now().format(context),
          avatar: "assets/images/user_placeholder.png", 
          reactions: [],
          replies: [], 
          isThreadOpen: false,
        ),
      );
    });
    
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: MyCircleChatroomAppBar(chat: widget.chat,isAdmin: widget.isAdmin,),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, 
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final currentMsg = _messages[index];

                bool isContinuation = false;
                if (index > 0) {
                  final previousMsg = _messages[index - 1];
                  isContinuation = previousMsg.senderName == currentMsg.senderName;
                }

                return GroupMessageCard(
                  key: ValueKey(currentMsg.id), 
                  grpmessage: currentMsg,
                  isContinuation: isContinuation,
                );
              },
            ),
          ),
          MessageInputField(onSend: _handleSendMessage),
        ],
      ),
    );
  }
}