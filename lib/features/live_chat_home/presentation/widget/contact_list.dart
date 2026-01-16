import 'package:flutter/material.dart';
import 'package:senior_circle/core/constants/contact.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/live_chat_chat_room_page.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/tag_chip.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/time_count.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/user_count.dart';

class ContactRoomList extends StatelessWidget {
  final List<Contact> roomList;

  const ContactRoomList({super.key, required this.roomList});
  bool _validImage(String? url) {
    if (url == null || url.isEmpty) return false;
    if (!url.startsWith("http")) return false;
    if (!url.contains(".")) return false;
    return true;
  }

  String timeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final list = roomList;

    if (list.isEmpty) {
      return const Center(
        child: Text('No contacts', style: TextStyle(color: Colors.black)),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      primary: false,
      itemCount: list.length + 1,
      itemBuilder: (context, index) {
        if (index == list.length) {
          return Container(
            color: const Color(0xFFF9F9F7),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: const Center(
              child: Text(
                'You have viewed all rooms',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }

        final room = list[index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return Builder(
                    builder: (innerContext) {
                      return Chatroom(
                        title: room.name,
                        imageUrl: room.image_url,
                        roomId: room.id,
                        adminId: room.admin_id!,
                      );
                    },
                  );
                },
              ),
            );
          },

          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: _validImage(room.image_url)
                      ? NetworkImage(room.image_url!)
                      : const AssetImage('assets/images/Frame_24.png')
                            as ImageProvider,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 6),

                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: room.interests
                            .map((tag) => TagChip(label: tag))
                            .toList(),
                      ),
                    ],
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TimeText(
                      time: room.lastMessageAt != null
                          ? timeAgo(room.lastMessageAt!)
                          : '',
                    ),

                    const SizedBox(height: 6),
                    UserCountBadge(count: 10),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, __) =>
          Divider(color: Colors.grey.shade300, thickness: 1, height: 1),
    );
  }
}
