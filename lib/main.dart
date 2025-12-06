import 'package:flutter/material.dart';
import 'package:senior_circle/features/createroom/presentation/create_room_screen.dart';
import 'package:senior_circle/theme/apptheme/app_theme.dart';

import 'package:senior_circle/features/livechat/ui/livechat_page.dart';
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
      home: const LiveChatPage(),
    );
  }
}
