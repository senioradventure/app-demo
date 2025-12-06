import 'package:flutter/material.dart';
import 'package:senior_circle/features/home/home_page.dart';
import 'package:senior_circle/features/my_circle/presentation/page/my_circle_page.dart';
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
      title: 'Flutter Demo',
       theme: AppTheme.lightMode,
      home: const MyCirclePage(),
    );
  }
}
