import 'package:flutter/material.dart';
import 'package:senior_circle/core/constants/contact.dart';
import 'package:senior_circle/features/createroom/presentation/create_room_screen.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/live_chat_chat_room_page.dart';
import 'package:senior_circle/features/live_chat_home/ui/presentation/main_bottom_nav.dart';

final ValueNotifier<bool> isListening = ValueNotifier<bool>(false);
final ValueNotifier<List<Contact>> filteredContactList =
    ValueNotifier<List<Contact>>(List.from(masterContactList));

class LiveChatPage extends StatelessWidget {
  const LiveChatPage({super.key});

  void _filterContacts(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      filteredContactList.value = List.from(masterContactList);
      return;
    }
    filteredContactList.value = masterContactList.where((c) {
      return c.contactFirstName.toLowerCase().contains(q);
    }).toList();
  }

  void _toggleFavourite(Contact contact) {
    final idx = masterContactList.indexOf(contact);
    if (idx >= 0) {
      masterContactList[idx].favourite = !masterContactList[idx].favourite;

      filteredContactList.value = List.from(filteredContactList.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      body: SafeArea(
        child: Container(
          color: const Color(0xFFF9F9F7),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15, left: 27),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Live Chat',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 4,
                ),
                child: TextFormField(
                  onChanged: _filterContacts,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hint: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 6, 0, 6),
                      child: Text(
                        'Search for rooms',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    prefixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                      child: Image.asset(
                        'assets/icons/search.png',
                        width: 10,
                        height: 10,
                      ),
                    ),

                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 35,
                      minHeight: 35,
                    ),

                    contentPadding: const EdgeInsets.fromLTRB(4, 4, 0, 4),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 228, 230, 231),
                      ),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 228, 230, 231),
                        width: 1.2,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 228, 230, 231),
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (ctx) {
                        return OutlinedButton(
                          onPressed: () async {
                            final RenderBox btn =
                                ctx.findRenderObject() as RenderBox;
                            final Offset pos = btn.localToGlobal(Offset.zero);
                            final Size size = btn.size;

                            await showMenu(
                              context: ctx,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              color: const Color(0xFFE8EFF5),
                              position: RelativeRect.fromLTRB(
                                pos.dx,
                                pos.dy + size.height + 6,
                                pos.dx + size.width,
                                0,
                              ),
                              items: [
                                PopupMenuItem(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    "Ernakulam",
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  value: "Ernakulam",
                                ),
                                PopupMenuItem(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    "Thrissur",
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  value: "Thrissur",
                                ),
                                PopupMenuItem(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    "Kottayam",
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  value: "Kottayam",
                                ),
                              ],
                            );
                          },

                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            backgroundColor: const Color(0xFFE8EFF5),
                            side: BorderSide.none,
                            minimumSize: const Size(0, 32),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.location_pin,
                                size: 18,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "by location",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: Colors.blueAccent,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(width: 15),

                    Builder(
                      builder: (ctx) {
                        return OutlinedButton(
                          onPressed: () async {
                            final RenderBox btn =
                                ctx.findRenderObject() as RenderBox;
                            final Offset pos = btn.localToGlobal(Offset.zero);
                            final Size size = btn.size;

                            await showMenu(
                              context: ctx,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              color: const Color(0xFFE8EFF5),
                              position: RelativeRect.fromLTRB(
                                pos.dx,
                                pos.dy + size.height + 6,
                                pos.dx + size.width,
                                0,
                              ),
                              items: [
                                PopupMenuItem(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    "Tea",
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  value: "Tea",
                                ),
                                PopupMenuItem(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    "Friends",
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                  value: "Friends",
                                ),
                              ],
                            );
                          },

                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            backgroundColor: const Color(0xFFE8EFF5),
                            side: BorderSide.none,
                            minimumSize: const Size(0, 32),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.filter_alt,
                                size: 18,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(width: 6),
                              Text(
                                "by interest",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 18,
                                color: Colors.blueAccent,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ValueListenableBuilder<List<Contact>>(
                    valueListenable: filteredContactList,
                    builder: (context, list, _) {
                      if (list.isEmpty) {
                        return const Center(
                          child: Text(
                            'No contacts',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }

                      return ListView.separated(
                        primary: false,
                        padding: EdgeInsets.zero,
                        itemCount: list.length + 1,
                        itemBuilder: (context, index) {
                          if (index == list.length) {
                            if (index == list.length) {
                              return Container(
                                color: const Color(0xFFF9F9F7),
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 200),
                                      Center(
                                        child: Text(
                                          'You have viewed all rooms',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 200),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Divider(
                              color: Colors.grey.shade300,
                              thickness: 1,
                              height: 0,
                            );
                          }

                          final c = list[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      Chatroom(title: c.contactFirstName),
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
                                    backgroundImage: const AssetImage(
                                      'assets/image/Frame_24.png',
                                    ),
                                    radius: 30,
                                  ),

                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 6,
                                          ),
                                          child: Text(
                                            c.contactFirstName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),

                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 4,
                                          children: [
                                            for (final tag in c.tags)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  tag,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      const Text(
                                        '32m ago',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 2,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(0xFF4A90E2),
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                              'assets/icons/user.png',
                                              width: 16,
                                              height: 16,
                                              color: Colors.white,
                                              filterQuality: FilterQuality.high,
                                            ),
                                            Text(
                                              '10',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              ),
                                            ),

                                            SizedBox(width: 4),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                          height: 1,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 23, bottom: 17),
        child: SizedBox(
          width: 50,
          height: 50,
          child: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            shape: const CircleBorder(),
            child: const Text(
              "+",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w300,
                color: Colors.white,
                height: 1,
              ),
            ),
            onPressed: () async {
              final result = await Navigator.push<Map<String, dynamic>?>(
                context,
                MaterialPageRoute(builder: (_) => const CreateRoomScreen()),
              );

              if (result != null) {
                final newContact = Contact(
                  contactFirstName: result['roomName'] ?? "Unnamed Room",
                  // add description / image if needed
                );

                masterContactList.add(newContact);
                filteredContactList.value = List.from(masterContactList);
              }
            },
          ),
        ),
      ),
    );
  }
}
