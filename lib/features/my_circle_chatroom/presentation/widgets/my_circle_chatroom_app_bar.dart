import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/chat/presentation/page/room_details.dart';
import 'package:senior_circle/features/chat/presentation/page/room_details_admin.dart';
import 'package:senior_circle/features/my_circle_home/models/my_circle_model.dart';

class MyCircleChatroomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MyCircleChatroomAppBar({
    super.key,
    required this.chat,
    this.isAdmin = false,
  });

  final MyCircle chat;
  final bool isAdmin;

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
          if (isAdmin) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatDetailsScreenadmin(liveChatRoomId: '',)),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatDetailsScreen()),
            );
          }
        },
        child: Row(
          children: [
            _buildAvatar(),
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
      ),
      actions: [
        IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Widget _buildAvatar() {
    final hasImage = chat.imageUrl != null && chat.imageUrl!.isNotEmpty;

    return ClipRRect(
      borderRadius: BorderRadius.circular(chat.isGroup ? 999 : 10),
      child: Container(
        width: 32,
        height: 32,
        color: AppColors.borderColor,
        child: hasImage
            ? Image.network(chat.imageUrl!, fit: BoxFit.cover)
            : Icon(chat.isGroup ? Icons.group : Icons.person, size: 18),
      ),
    );
  }
}
