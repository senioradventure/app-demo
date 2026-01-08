import 'package:flutter/material.dart';
import 'package:senior_circle/features/chat/presentation/page/room_details.dart';
import 'package:senior_circle/features/chat/presentation/page/room_details_admin.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/main_bottom_nav.dart';
import 'package:senior_circle/features/tab/tab.dart';

class ChatHeaderWidget extends StatelessWidget {
  final String? title;
  final String? imageUrl;
  final bool isAdmin;
  final String liveChatRoomId;

  const ChatHeaderWidget({
    super.key,
    required this.liveChatRoomId,
    required this.title,
    required this.imageUrl,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        if (!isAdmin) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatDetailsScreen()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ChatDetailsScreenadmin(liveChatRoomId: liveChatRoomId,)),
          );
        }
      },
      child: Container(
        height: 60,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  currentPageIndex.value = 0;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => TabSelectorWidget()),
                    (route) => false,
                  );
                },
              ),
              CircleAvatar(
                radius: 20,
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl!)
                    : const AssetImage("assets/image/Frame_24.png")
                          as ImageProvider,
              ),
              const SizedBox(width: 10),
              Text(
                (title != null && title!.length > 14)
                    ? '${title!.substring(0, 14)}...'
                    : (title ?? 'Chai Talks'),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Text(
                '10 Active',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 2),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Color(0xFF5C5C5C)),
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
