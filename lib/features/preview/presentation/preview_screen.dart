import 'package:flutter/material.dart';
import 'package:senior_circle/core/common/widgets/bottom_button.dart';
import 'package:senior_circle/core/common/widgets/common_app_bar.dart';
import 'package:senior_circle/core/common/widgets/details_tag_widget.dart';
import 'package:senior_circle/core/common/widgets/member_listview.dart';
import 'package:senior_circle/features/details/model/chatroom_member_model.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/live_chat_chat_room_page.dart';
import 'package:senior_circle/features/preview/models/preview_details_model.dart';
import 'package:senior_circle/features/preview/presentation/widgets/preview_screen_caution_container.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MemberModel> members = membersdata
        .map((e) => MemberModel.fromJson(e))
        .toList();
    final details = PreviewDetailsModel.fromJson(detailsJson);
    return Scaffold(
      appBar: CommonAppBar(title: "Preview"),
      body: Column(
        children: [
          // Header / details area (fixed height based on content)
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DetailsTagWidget(
                  imageUrl: details.imageUrl,
                  name: details.name,
                  interests: details.interests,
                  description: details.description,
                ),
                const SizedBox(height: 20),
                Text(
                  "Members",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
          Expanded(child: MembersListView(members: members)),
          CautionWidget(),
        ],
      ),
      bottomNavigationBar: BottomButton(
  onTap: () {
    // 🔹 Clear previous messages
    chatMessages.value = [];

    // 🔹 Navigate to chat page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => Chatroom(
          title: details.name,
          isAdmin: true,
          isNewRoom: true, 
        ),
      ),
    );
  },
  buttonText: "CREATE ROOM",
),

    );
  }
}

//sample chatroom details json
final Map<String, dynamic> detailsJson = {
  "imageUrl":
      "https://imgs.search.brave.com/ZLuinyHs1AsoMbvdhGtNru-ngFCQU_ZkPNQI5RoSA7Q/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93d3cu/c2h1dHRlcnN0b2Nr/LmNvbS9pbWFnZS1w/aG90by9lYXJ0aGVu/LXRlYS1jdXAtY2hh/aS1rdWxoYWQtMjYw/bnctMjI3ODkzMDMw/MS5qcGc",
  "name": "Chai Talks",
  "interests": ["Cooking", "Travel", "Music"],
  "description":
      "This is a chatroom for people who love to talk about chai and share their experiences.",
};

//sample members list
final List<Map<String, dynamic>> membersdata = [
  {
    "url": "https://randomuser.me/api/portraits/men/32.jpg",
    "name": "Alex Johnson",
    "admin": 1,
  },
  {
    "url": "https://randomuser.me/api/portraits/women/45.jpg",
    "name": "Sofia Martinez",
    "admin": 0,
  },
  {
    "url": "https://randomuser.me/api/portraits/men/12.jpg",
    "name": "Rahul Verma",
    "admin": 0,
  },
];