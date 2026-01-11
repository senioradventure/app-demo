import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/individual_chat/presentation/widgets/profile_bottom_sheet.dart';

class MyCircleIndividualAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MyCircleIndividualAppBar({
    super.key,
    required this.userName,
    required this.profileUrl,
    required this.userId,
  });
  final String userName;
  final String? profileUrl;
  final String userId;

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
            CircleAvatar(
              radius: 16,
              backgroundImage:
                  profileUrl != null && profileUrl!.isNotEmpty
                      ? NetworkImage(profileUrl!)
                      : null,
              child: profileUrl == null || profileUrl!.isEmpty
                  ? const Icon(Icons.person, size: 16)
                  : null,
            ),
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
        IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
