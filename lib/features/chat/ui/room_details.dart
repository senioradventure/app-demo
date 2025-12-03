import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: ChatDetailsScreen()));
}

class ChatDetailsScreen extends StatelessWidget {
  const ChatDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            /*Go back to the previous screen*/
            ;
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          'Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              /*More details*/
              ;
            },
            icon: Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: Container(),
    );
  }
}
