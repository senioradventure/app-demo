import 'package:flutter/material.dart';

class AddChatWidget extends StatelessWidget {
  const AddChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height *0.1, right: 24.0),
            child: FloatingActionButton(
              onPressed: () {
                // Handle add chat action
              },
              shape: const CircleBorder(),
              backgroundColor: Color(0xFF4A90E2),
              elevation: 0,
              child: const Icon(Icons.add, color: Colors.white, size: 40,),
            ),
      ),
    );
  }
}