import 'package:flutter/material.dart';
import 'package:senior_circle/core/constants/contact.dart';
import 'package:senior_circle/core/constants/strings/lists.dart';
import 'package:senior_circle/features/createroom/presentation/create_room_screen.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/live_chat_chat_room_page.dart';
import 'package:senior_circle/features/live_chat_home/ui/presentation/widget/search_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveChatPage extends StatelessWidget {
  


  LiveChatPage({super.key});
  final ValueNotifier<bool> isListening = ValueNotifier<bool>(false);
final ValueNotifier<List<Contact>> filteredContactList =
    ValueNotifier<List<Contact>>([]);
final ValueNotifier<List<String>> locationList = ValueNotifier<List<String>>([]);
String? selectedLocation;
String? selectedInterest;
String _currentSearch = "";
final ValueNotifier<List<Contact>> allRooms =
    ValueNotifier<List<Contact>>([]);

void _filterContacts(String query) {
  _currentSearch = query.trim().toLowerCase();
  applyFilters();
}

void applyFilters() {
 
  List<Contact> result = List.from(allRooms.value);


  if (selectedLocation != null && selectedLocation!.isNotEmpty) {
    result = result.where((room) {
      return room.location_id != null &&
          room.location_id!.toLowerCase() ==
              selectedLocation!.toLowerCase();
    }).toList();
  }

 
  if (selectedInterest != null && selectedInterest!.isNotEmpty) {
    result = result.where((room) {
      return room.interests.contains(selectedInterest);
    }).toList();
  }


  if (_currentSearch.isNotEmpty) {
    result = result.where((room) {
      return room.name.toLowerCase().contains(_currentSearch);
    }).toList();
  }


  filteredContactList.value = result;
}


Future<void> fetchLocations() async {
  final supabase = Supabase.instance.client;

  final response = await supabase
      .from('locations')
      .select('name');

  final uniqueLocations = response
      .map<String>((row) => row['name'] as String)
      .toSet()
      .toList();

  locationList.value = uniqueLocations;
}

 Future<void> fetchRooms() async {
  final supabase = Supabase.instance.client;

  final response = await supabase.from('live_chat_rooms').select();

  final rooms =
      response.map<Contact>((room) => Contact.fromJson(room)).toList();


  allRooms.value = rooms;

  applyFilters();
}




  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
  if (locationList.value.isEmpty) {
    fetchLocations();
  }
  if (filteredContactList.value.isEmpty) {
    fetchRooms();
  }
});



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
                child: SearchTextField(onChanged: _filterContacts),
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

                            final selected = await showMenu(
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
    const PopupMenuItem(
      value: "None",
      child: Text("None",
      style: TextStyle(color: Colors.black)),
    ),
    ...locationList.value.map((loc) {
      return PopupMenuItem(
        value: loc,
        child: Text(loc, style: TextStyle(color: Colors.black87)),
      );
    }).toList(),
  ],
);

if (selected != null) {
  selectedLocation = (selected == "None") ? null : selected;
  applyFilters();
}


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
                            children: [
                              const Icon(
                                Icons.location_pin,
                                size: 18,
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(width: 6),
                              Text(
  selectedLocation == null ? "by location" : selectedLocation!,
  style: const TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w500,
  ),
),

                              const SizedBox(width: 4),
                              const Icon(
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

                         final selected = await showMenu(
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
    const PopupMenuItem(
      value: "None",
      child: Text("None",
      style: TextStyle(color: Colors.black)),
    ),
    ...AppLists.interests.map((interest) {
      return PopupMenuItem(
        value: interest,
        child: Text(interest, style: TextStyle(color: Colors.black87)),
      );
    }).toList(),
  ],
);

if (selected != null) {
  selectedInterest = (selected == "None") ? null : selected;
  applyFilters();
}


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
                            children: [
                              const Icon(
                                Icons.filter_alt,
                                size: 18,
                                color: Colors.blueAccent,
                              ),
                              const SizedBox(width: 6),
                              Text(
  selectedInterest == null ? "by interest" : selectedInterest!,
  style: const TextStyle(
    color: Colors.black87,
    fontWeight: FontWeight.w500,
  ),
),

                              const SizedBox(width: 4),
                              const Icon(
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
                                      SizedBox(height: 300),
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
                                      Chatroom(title: c.name, imageUrl: c.image_url),
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
  backgroundImage: c.image_url != null
      ? NetworkImage(c.image_url!)
      : const AssetImage('assets/image/Frame_24.png') as ImageProvider,
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
                                            c.name,
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
                                            for (final tag in c.interests)
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
    await Supabase.instance.client.from('live_chat_rooms').insert({
      'name': result['roomName'],
      'image_url': result['imageUrl'],
      'interests': [],
    });

    fetchRooms();  
  }
},

          ),
        ),
      ),
    );
  }
}
