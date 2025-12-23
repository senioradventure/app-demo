import 'package:flutter/material.dart';
import 'package:senior_circle/core/constants/contact.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/live_chat_chat_room_page.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/tag_chip.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/time_count.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/user_count.dart';

class ContactRoomList extends StatelessWidget {
  final ValueNotifier<List<Contact>> roomListNotifier;

  const ContactRoomList({super.key, required this.roomListNotifier});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Contact>>(
      valueListenable: roomListNotifier,
      builder: (context, list, _) {
        if (list.isEmpty) {
          return const Center(
            child: Text('No contacts', style: TextStyle(color: Colors.black)),
          );
        }

        return ListView.separated(
          primary: false,
          padding: EdgeInsets.zero,
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
                    builder: (_) =>
                        Chatroom(title: room.name, imageUrl: room.image_url),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 14,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: room.image_url != null
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
                        TimeText(time: "32m ago"),
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
      },
    );
  }
}
