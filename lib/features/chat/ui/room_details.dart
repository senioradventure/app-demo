import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: ChatDetailsScreen(),
  ));
}

class ChatDetailsScreen extends StatelessWidget {
  const ChatDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(),
    );
  }
}