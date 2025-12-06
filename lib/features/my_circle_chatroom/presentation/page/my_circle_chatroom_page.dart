import 'package:flutter/material.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_app_bar.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_messages.dart';

class MyCircleChatroomPage extends StatefulWidget {
  const MyCircleChatroomPage({super.key});

  @override
  State<MyCircleChatroomPage> createState() => _MyCircleChatroomPageState();
}

class _MyCircleChatroomPageState extends State<MyCircleChatroomPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
     body: Column(
        children: [
          MyCircleChatroomAppBar(),
          Expanded(
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return MessageCard(message: messages[index]);
          },
        ),
      ),
        ],
     ),
      

    );
  }
}