import 'package:flutter/material.dart';
import 'package:senior_circle/features/chat/ui/room_details.dart';
import 'package:senior_circle/features/my_circle_home/models/chat_model.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';
import 'package:senior_circle/theme/texttheme/text_theme.dart';

class MyCircleChatroomAppBar extends StatelessWidget {
  const MyCircleChatroomAppBar({super.key, required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Container(
          height: MediaQuery.of(context).size.height * 0.1,
          color: AppColors.backgroundColor,
          child: InkWell(
      onTap: () {
        
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const ChatDetailsScreen(), 
          ),
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        padding: const EdgeInsets.only(top: 24, left: 0, right: 12, bottom: 0),
        
        color: AppColors.backgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            if (chat.isGroup)
              CircleAvatar(
                radius: 18,
                backgroundImage: chat.imageUrl.isNotEmpty
                    ? AssetImage(chat.imageUrl)
                    : const AssetImage('assets/images/avatar.png'),
              ),
            if (!chat.isGroup)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: chat.imageUrl.isNotEmpty
                    ? Image.asset(
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
            const SizedBox(width: 10),
            Text(
              chat.name,
              style: AppTextTheme.lightTextTheme.headlineMedium,
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(
                Icons.more_vert,
                color: Color(0xFF5C5C5C),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {},
            ),
          ],
        ),
      ),
    ),
        );
  }
}