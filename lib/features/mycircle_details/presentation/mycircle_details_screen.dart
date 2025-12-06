import 'package:flutter/material.dart';
import 'package:senior_circle/common/widgets/common_app_bar.dart';
import 'package:senior_circle/common/widgets/details_widget.dart';
import 'package:senior_circle/common/widgets/member_listview.dart';
import 'package:senior_circle/features/details/presentation/widgets/details_screen_members_headline_widget.dart';
import 'package:senior_circle/features/details/presentation/widgets/details_screen_show_more_button.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    final visibleMembers = showAll ? members : members.take(8).toList();

    return Scaffold(
      appBar: CommonAppBar(title: "Details"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailsWidget(
                    imageUrl:
                        "https://imgs.search.brave.com/ZLuinyHs1AsoMbvdhGtNru-ngFCQU_ZkPNQI5RoSA7Q/rs:fit:500:0:1:0/g:ce/aHR0cHM6Ly93d3cu/c2h1dHRlcnN0b2Nr/LmNvbS9pbWFnZS1w/aG90by9lYXJ0aGVu/LXRlYS1jdXAtY2hh/aS1rdWxoYWQtMjYw/bnctMjI3ODkzMDMw/MS5qcGc",
                    name: "Chai Talks",
                    interests: [],
                    description: "",
                  ),
                  const SizedBox(height: 14),
                  MemberHeadline(onAddMember: () {}),
                ],
              ),
            ),

            MembersListView(members: visibleMembers),
            ShowMoreButton(
              expanded: showAll,
              onTap: () {
                setState(() {
                  showAll = !showAll;
                });
              },
            ),
          ],
        ),
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
  {
    "url": "https://randomuser.me/api/portraits/women/68.jpg",
    "name": "Emily Carter",
    "admin": 0,
  },
  {
    "url": "https://randomuser.me/api/portraits/men/77.jpg",
    "name": "Daniel Smith",
    "admin": 0,
  },
  {
    "url": "https://randomuser.me/api/portraits/women/21.jpg",
    "name": "Priya Nair",
    "admin": 0,
  },
  {
    "url": "https://randomuser.me/api/portraits/men/5.jpg",
    "name": "Mohammed Farhan",
    "admin": 0,
  },
  {
    "url": "https://randomuser.me/api/portraits/women/9.jpg",
    "name": "Aisha Khan",
    "admin": 0,
  },
  {
    "url": "https://randomuser.me/api/portraits/men/49.jpg",
    "name": "Chris Evans",
    "admin": 0,
  },
  {
    "url": "https://randomuser.me/api/portraits/women/16.jpg",
    "name": "Laura Parker",
    "admin": 0,
  },
  {
    "url": "https://randomuser.me/api/portraits/men/18.jpg",
    "name": "Arjun Menon",
    "admin": 0,
  },
  {
    "url": "https://randomuser.me/api/portraits/women/33.jpg",
    "name": "Nina George",
    "admin": 0,
  },
  {
    "url": "https://randomuser.me/api/portraits/men/81.jpg",
    "name": "Benjamin Lewis",
    "admin": 0,
  },
  {
    "url": "https://randomuser.me/api/portraits/women/71.jpg",
    "name": "Sarah Wilson",
    "admin": 0,
  },
  {
    "url": "https://randomuser.me/api/portraits/men/29.jpg",
    "name": "Vikram Rao",
    "admin": 0,
  },
];
