import 'package:flutter/material.dart';
import 'package:senior_circle/features/createroom/presentation/create_room_screen.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/live-chat_chat_room_page.dart';
import 'package:senior_circle/features/live_chat_home/ui/presentation/live-chat_home_page.dart';
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
      title: 'Senior Circle',
      theme: AppTheme.lightMode,
      darkTheme: AppTheme.darkMode,
      debugShowCheckedModeBanner: false,
      home: const Chatroom(),
    );
  }
}
