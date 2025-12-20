import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/my_circle_home/models/circle_chat_model.dart';

class MyCircleChatroomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MyCircleChatroomAppBar({super.key, required this.chat});

  final CircleChat chat;

  ImageProvider _getAvatar() {
    if (chat.imageUrl != null && chat.imageUrl!.isNotEmpty) {
      return NetworkImage(chat.imageUrl!);
    }
    return const AssetImage('assets/images/avatar.png');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.backgroundColor,
      centerTitle: false,
      title: Row(
        children: [
          chat.isGroup
              ? CircleAvatar(
                  radius: 18,
                  backgroundImage: _getAvatar(),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image(
                    image: _getAvatar(),
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              chat.name,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.iconColor),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
