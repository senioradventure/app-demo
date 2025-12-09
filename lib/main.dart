import 'package:flutter/material.dart';
import 'package:senior_circle/features/home/home_page.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/page/my_circle_chatroom_page.dart';
import 'package:senior_circle/features/my_circle_home/presentation/page/my_circle_home_page.dart';
import 'package:senior_circle/theme/apptheme/app_theme.dart';
import 'package:senior_circle/features/live-chat/chatroom_page.dart';


void main() {
  runApp(const SeniorCircleApp());
}

class SeniorCircleApp extends StatelessWidget {
  const SeniorCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Senior Circle',
       theme: AppTheme.lightMode,
       darkTheme: AppTheme.darkMode,
      home: const MyCircleChatroomPage(),
    );
  }
}
