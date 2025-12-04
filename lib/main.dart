import 'package:flutter/material.dart';
import 'package:senior_circle/features/home/home_page.dart';
import 'package:senior_circle/features/my_circle/page/my_circle_page.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade800),
      ),
      home: const MyCirclePage(),
    );
  }
}
