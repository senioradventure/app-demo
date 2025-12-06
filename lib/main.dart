import 'package:flutter/material.dart';
import 'package:senior_circle/features/home/home_page.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/page/my_circle_chatroom_page.dart';
import 'package:senior_circle/features/my_circle_home/presentation/page/my_circle_home_page.dart';
import 'package:senior_circle/theme/apptheme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Senior Circle',
       theme: AppTheme.lightMode,
      home: const MyCircleChatroomPage(),
    );
  }
}
