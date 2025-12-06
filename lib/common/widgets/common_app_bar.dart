import 'package:flutter/material.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int? activeCount;

  const CommonAppBar({super.key, required this.title, this.activeCount});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,

      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.iconColor),
        onPressed: () => Navigator.pop(context),
      ),

      title: Text(title, style: Theme.of(context).textTheme.headlineMedium),
      centerTitle: true,

      actions: [
        if (activeCount != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              "$activeCount active",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.buttonBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.iconColor),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
