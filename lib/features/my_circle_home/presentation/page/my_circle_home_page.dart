import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';
import 'package:senior_circle/features/chat/ui/circle_creation_screen.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/page/my_circle_group_chat_page.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/page/my_circle_individual_chat_page.dart';
import 'package:senior_circle/features/my_circle_home/models/circle_chat_model.dart';
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
    'adminId': 'user_123', // 👈 group
    'time': DateTime.now().subtract(const Duration(minutes: 32)),
    'unreadCount': 2,
  },
  {
    'name': 'Chai Talks',
    'lastMessage': 'You: how about we start another project?',
    'imageUrl': 'https://picsum.photos/400/400?random=1',
    'adminId': 'user_123', // 👈 group
    'time': DateTime.now().subtract(const Duration(hours: 2)),
  },
  {
    'name': 'Ramsy',
    'lastMessage': 'You: How are you today?',
    'imageUrl':
        'https://stored-cf.slickpic.com/Mjg1ODI1MDZmMThjNTg,/20211004/MTgwNzc0ODk4ODBj/pn/600/radiant-smiles-close-up-portrait-beautiful-woman.jpg.webp',
    'adminId': null, // 👈 DM
    'time': DateTime.now().subtract(const Duration(hours: 4)),
  },
  {
    'name': 'Reena',
    'lastMessage': 'You: How are you?',
    'imageUrl':
        'https://stored-cf.slickpic.com/Mjg1ODI1MDZmMThjNTg,/20211004/MTgwNzc0ODk4ODBj/pn/600/radiant-smiles-close-up-portrait-beautiful-woman.jpg.webp',
    'adminId': null, // 👈 DM
    'time': DateTime.now().subtract(const Duration(days: 1)),
  },
];


  late final List<CircleChat> chats = chatData
    .map(
      (data) => CircleChat(
        name: data['name'],
        lastMessage: data['lastMessage'],
        imageUrl: data['imageUrl'],
        adminId: data['adminId'], 
        time: data['time'],       
        unreadCount: data['unreadCount'] ?? 0,
      ),
    )
    .toList();

  List<CircleChat> foundResults = [];
  @override
void initState() {
  chats.sort((a, b) => b.time!.compareTo(a.time!));
  foundResults = chats;
  super.initState();
}


  void runfilter(String enteredKeyword) {
    List<CircleChat> results = [];
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

  void navigateToChatRoom(CircleChat chat) {
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
          ),
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
