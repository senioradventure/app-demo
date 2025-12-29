import 'package:flutter/material.dart';
import 'package:senior_circle/core/common/widgets/common_app_bar.dart';
import 'package:senior_circle/core/common/widgets/search_bar_widget.dart';
import 'package:senior_circle/core/constants/friends_list.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/view_friends/presentation/widgets/friend_tile_widget.dart';

class ViewFriendsPage extends StatelessWidget {
  const ViewFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Friends'),
      body: Column(
        children: [
          const SizedBox(height: 12),
          SearchBarWidget(hintText: 'Search Friends',),
          const SizedBox(height: 12),
           Expanded(
            child: ListView.separated(
              itemCount: friends.length,
              separatorBuilder: (_, __) =>
                  Divider(color: AppColors.borderColor, height: 1),
              itemBuilder: (context, index) {
                return FriendTile(friend: friends[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}