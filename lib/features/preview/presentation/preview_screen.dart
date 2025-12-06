import 'package:flutter/material.dart';
import 'package:senior_circle/common/widgets/bottom_button.dart';
import 'package:senior_circle/common/widgets/common_app_bar.dart';
import 'package:senior_circle/common/widgets/details_widget.dart';
import 'package:senior_circle/common/widgets/member_listview.dart';
import 'package:senior_circle/features/preview/presentation/widgets/preview_screen_caution_container.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Preview", activeCount: null),
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
                DetailsWidget(
                  imageUrl:
                      "https://imgs.search.brave.com/ZLuinyHs1AsoMbvdhGtNru-ngFCQU_ZkPNQI5RoSA7Q/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93d3cu/c2h1dHRlcnN0b2Nr/LmNvbS9pbWFnZS1w/aG90by9lYXJ0aGVu/LXRlYS1jdXAtY2hh/aS1rdWxoYWQtMjYw/bnctMjI3ODkzMDMw/MS5qcGc",
                  name: "Chai Talks",
                  interests: ["Tea Lovers", "Cultural Exchange", "Book Club"],
                  description:
                      "Masala chai, the spiced milk tea widely loved in India today, was actually popularized in the 20th century. Indians then added spices and milk to make it their own version.",
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
        onTap: () {},
        buttonText: "CREATE ROOM",
      ),
    );
  }
}

//dummy members data
final List<Map<String, dynamic>> members = [
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
