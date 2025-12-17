import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';
import 'package:senior_circle/features/chat/ui/circle_creation_screen.dart';
import 'package:senior_circle/features/live_chat_home/ui/presentation/main_bottom_nav.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/page/my_circle_group_chat_page.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/page/my_circle_individual_chat_page.dart';
import 'package:senior_circle/features/my_circle_home/models/chat_model.dart';
import 'package:senior_circle/features/my_circle_home/presentation/widgets/my_circle_home_add_chat_widget.dart';
import 'package:senior_circle/features/my_circle_home/presentation/widgets/my_circle_home_chat_list_widget.dart';
import 'package:senior_circle/features/my_circle_home/presentation/widgets/my_circle_home_search_bar_widget.dart';
import 'package:senior_circle/features/my_circle_home/presentation/widgets/my_circle_home_starred_message_widget.dart';

class MyCirclePage extends StatefulWidget {
  const MyCirclePage({super.key});

  @override
  State<MyCirclePage> createState() => _MyCirclePageState();
}

class _MyCirclePageState extends State<MyCirclePage> {
  final List<Map<String, dynamic>> chatData = [
    {
      'name': 'Chai Talks',
      'lastMessage': 'Ram: How are you?',
      'imageUrl': 'assets/images/group_icon.png',
      'isGroup': true,
      'time': '32m ago',
      'unreadCount': 2,
    },
    {
      'name': 'Chai Talks',
      'lastMessage': 'You: how about we start another project?',
      'imageUrl': 'assets/images/group_icon.png',
      'isGroup': true,
      'time': '10:45 AM',
    },
    {
      'name': 'Ramsy',
      'lastMessage': 'You: How are you today?',
      'imageUrl': 'assets/images/user_icon.png',
      'isGroup': false,
      'time': '9:30 AM',
    },
    {
      'name': 'Reena',
      'lastMessage': 'You: How are you?',
      'imageUrl': 'assets/images/user_icon.png',
      'isGroup': false,
      'time': 'yesterday',
    },
  ];

  late final List<Chat> chats = chatData
      .map(
        (data) => Chat(
          name: data['name'],
          lastMessage: data['lastMessage'],
          imageUrl: data['imageUrl'],
          isGroup: data['isGroup'],
          time: data['time'],
          unreadCount: data['unreadCount'] ?? 0,
        ),
      )
      .toList();

  List<Chat> foundResults = [];
  @override
  void initState() {
    foundResults = chats;
    super.initState();
  }

  void runfilter(String enteredKeyword) {
    List<Chat> results = [];
    if (enteredKeyword.isEmpty) {
      results = chats;
    } else {
      results = chats
          .where(
            (chat) =>
                chat.name.toLowerCase().contains(enteredKeyword.toLowerCase()),
          )
          .toList();
    }

    setState(() {
      foundResults = results;
    });
  }

  void navigateToChatRoom(Chat chat) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => chat.isGroup
            ? MyCircleGroupChatPage(chat: chat)
            : MyCircleIndividualChatPage(chat: chat),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'My Circle',
          textAlign: TextAlign.left,
          style: AppTextTheme.lightTextTheme.headlineLarge,
        ),
        iconTheme: IconThemeData(color: AppColors.iconColor),
      ),
      body: Column(
        children: [
          SearchBarWidget(onChanged: (value) => runfilter(value)),
          SizedBox(height: 8),
          StarredMessageWidget(),
          Expanded(
            child: ChatListWidget(
              foundResults: foundResults,
              onChatTap: navigateToChatRoom,
            ),
          ),
          AddChatWidget(destinationPage: const CircleCreationScreen()),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        child: const MainBottomNavBar(currentIndex: 1),
      ),
    );
  }
}
