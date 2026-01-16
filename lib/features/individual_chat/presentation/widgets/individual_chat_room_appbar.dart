import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/individual_chat/presentation/widgets/profile_bottom_sheet.dart';
import 'package:senior_circle/local_messages_debug_page.dart';

class MyCircleIndividualAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MyCircleIndividualAppBar({
    super.key,
    required this.userName,
    required this.profileUrl,
    required this.userId,
    required this.id,
  });
  final String userName;
  final String profileUrl;
  final String userId;
  final String id;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundColor,
      centerTitle: false,
      elevation: 0,
      leading: const BackButton(),
      leadingWidth: 48,
      titleSpacing: 0,
      title: InkWell(
        onTap: () {
          showUserProfileBottomSheet(context, userId);
        },
        child: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(profileUrl), radius: 16),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                userName,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    LocalMessagesDebugPage(testConversationId: id),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
