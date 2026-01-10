import 'package:flutter/material.dart';
import 'package:senior_circle/features/chat/presentation/page/room_details.dart';

class MembersListFullscreen extends StatefulWidget {
  const MembersListFullscreen({super.key});

  @override
  State<MembersListFullscreen> createState() => _MembersListFullscreenState();
}

class _MembersListFullscreenState extends State<MembersListFullscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            ...List.generate(
              50,
              (index) => Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 22.0,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  title: Text(
                    'Chai Talks',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
