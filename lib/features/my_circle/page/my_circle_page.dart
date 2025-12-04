import 'package:flutter/material.dart';
import 'package:senior_circle/features/my_circle/widgets/add_chat_widget.dart';
import 'package:senior_circle/features/my_circle/widgets/chat_list_widget.dart';
import 'package:senior_circle/features/my_circle/widgets/search_bar_widget.dart';
import 'package:senior_circle/features/my_circle/widgets/starred_message_widget.dart';

class MyCirclePage extends StatelessWidget {
  const MyCirclePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          'My Circle',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
      ),
      body: Column(
        children: [
          SearchBarWidget(),
          SizedBox(height: 8),
          StarredMessageWidget(),
          Expanded(
            child: ChatListWidget(
              chats: [
                Chat(
                  name: 'Chai Talks',
                  lastMessage: 'Ram: How are you?',
                  imageUrl: 'assets/images/group_icon.png',
                  isGroup: true,
                  time: '32m ago',
                  unreadCount: 2,
                ),
                Chat(
                  name: 'Chai Talks',
                  lastMessage: 'You: how about we start another project?',
                  imageUrl: 'assets/images/group_icon.png',
                  isGroup: true,
                  time: '10:45 AM',
                ),
                Chat(
                  name: 'Ramsy',
                  lastMessage: 'You: How are you today?',
                  imageUrl: 'assets/images/user_icon.png',
                  isGroup: false,
                  time: '9:30 AM',
                ),
              ],
            ),
          ),
          AddChatWidget(),
        ],
      ),
    );
  }
}
