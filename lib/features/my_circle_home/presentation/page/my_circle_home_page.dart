import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

class MyCircleHomePage extends StatefulWidget {
  const MyCircleHomePage({super.key});

  @override
  State<MyCircleHomePage> createState() => _MyCircleHomePageState();
}

class _MyCircleHomePageState extends State<MyCircleHomePage> {
  final List<Map<String, dynamic>> chatData = [
    {
      'name': 'Chai Talks',
      'lastMessage': 'Ram: How are you?',
      'imageUrl': 'https://picsum.photos/400/400?random=1',
      'isGroup': true,
      'time': '32m ago',
      'unreadCount': 2,
    },
    {
      'name': 'Chai Talks',
      'lastMessage': 'You: how about we start another project?',
      'imageUrl': 'https://picsum.photos/400/400?random=1',
      'isGroup': true,
      'time': '10:45 AM',
    },
    {
      'name': 'Ramsy',
      'lastMessage': 'You: How are you today?',
      'imageUrl':
          'https://stored-cf.slickpic.com/Mjg1ODI1MDZmMThjNTg,/20211004/MTgwNzc0ODk4ODBj/pn/600/radiant-smiles-close-up-portrait-beautiful-woman.jpg.webp',
      'isGroup': false,
      'time': '9:30 AM',
    },
    {
      'name': 'Reena',
      'lastMessage': 'You: How are you?',
      'imageUrl':
          'https://stored-cf.slickpic.com/Mjg1ODI1MDZmMThjNTg,/20211004/MTgwNzc0ODk4ODBj/pn/600/radiant-smiles-close-up-portrait-beautiful-woman.jpg.webp',
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
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.lightGray,
        title: Text(
          'My Circle',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 24,
            color: AppColors.textBlack,
            fontWeight: FontWeight.bold,
          )
        ),
        iconTheme: IconThemeData(color: AppColors.iconColor),
      ),
      body: Column(
        children: [
          SearchBarWidget(onChanged: (value) => runfilter(value)),
          SizedBox(height: 4),
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
    );
  }
}
