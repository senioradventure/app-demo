import 'package:flutter/material.dart';
import 'package:senior_circle/features/my_circle/presentation/widgets/add_chat_widget.dart';
import 'package:senior_circle/features/my_circle/presentation/widgets/chat_list_widget.dart';
import 'package:senior_circle/features/my_circle/presentation/widgets/search_bar_widget.dart';
import 'package:senior_circle/features/my_circle/presentation/widgets/starred_message_widget.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';
import 'package:senior_circle/theme/texttheme/text_theme.dart';

class MyCirclePage extends StatefulWidget {
  const MyCirclePage({super.key});

  @override
  State<MyCirclePage> createState() => _MyCirclePageState();
}

class _MyCirclePageState extends State<MyCirclePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Circle',
          textAlign: TextAlign.left,
          style: AppTextTheme.lightTextTheme.headlineLarge,
        ),
        iconTheme: IconThemeData(color: AppColors.iconColor),
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
