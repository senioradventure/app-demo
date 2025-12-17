import 'package:flutter/material.dart';
import 'package:senior_circle/features/chat/ui/room_details.dart';
import 'package:senior_circle/features/my_circle_home/models/chat_model.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';

class MyCircleChatroomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyCircleChatroomAppBar({super.key, required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.backgroundColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.iconColor),
        onPressed: () => Navigator.pop(context),
      ),
  leadingWidth: 24,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        
          if (chat.isGroup)
            CircleAvatar(
              radius: 18,
              backgroundImage: chat.imageUrl.isNotEmpty
                  ? NetworkImage(chat.imageUrl)
                  : AssetImage('assets/images/avatar.png'),
            ),
          if (!chat.isGroup)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: chat.imageUrl.isNotEmpty
                  ? Image.network(
                      chat.imageUrl,
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/avatar.png',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                    ),
            ),
          const SizedBox(width: 12),
          Text(chat.name, style: Theme.of(context).textTheme.headlineMedium),
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
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
