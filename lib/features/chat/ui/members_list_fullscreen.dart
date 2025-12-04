import 'package:flutter/material.dart';
import 'package:senior_circle/features/chat/ui/room_details.dart';

class MembersListFullscreen extends StatefulWidget {
  const MembersListFullscreen({super.key});

  @override
  State<MembersListFullscreen> createState() => _MembersListFullscreenState();
}

class _MembersListFullscreenState extends State<MembersListFullscreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => const ChatDetailsScreen(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
    );
  }
}
