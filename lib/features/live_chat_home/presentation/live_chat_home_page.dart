import 'package:flutter/material.dart';
import 'package:senior_circle/core/constants/contact.dart';
import 'package:senior_circle/core/constants/strings/lists.dart';
import 'package:senior_circle/features/createroom/presentation/create_room_screen.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/app_bar.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/contact_list.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/floating_button.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/interest_filter_button.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/location_filter_button.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/search_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveChatPage extends StatelessWidget {
  LiveChatPage({super.key});
  final ValueNotifier<bool> isListening = ValueNotifier<bool>(false);
  final ValueNotifier<List<String>> interestList = ValueNotifier<List<String>>(
    AppLists.interests,
  );

  final ValueNotifier<List<Contact>> filteredContactList =
      ValueNotifier<List<Contact>>([]);
  final ValueNotifier<List<String>> locationList = ValueNotifier<List<String>>(
    [],
  );
  final ValueNotifier<String?> selectedLocation = ValueNotifier<String?>(null);
  final ValueNotifier<String?> selectedInterest = ValueNotifier<String?>(null);
  final ValueNotifier<String> currentSearch = ValueNotifier<String>("");

  final ValueNotifier<List<Contact>> allRooms = ValueNotifier<List<Contact>>(
    [],
  );

  void _filterContacts(String query) {
    currentSearch.value = query.trim().toLowerCase();
    applyFilters();
  }

  void applyFilters() {
    List<Contact> result = List.from(allRooms.value);

    if (selectedLocation.value != null && selectedLocation.value!.isNotEmpty) {
      result = result.where((room) {
        return room.location_id != null &&
            room.location_id!.toLowerCase() ==
                selectedLocation.value!.toLowerCase();
      }).toList();
    }

    if (selectedInterest.value != null && selectedInterest.value!.isNotEmpty) {
      result = result.where((room) {
        return room.interests.contains(selectedInterest.value);
      }).toList();
    }

    if (currentSearch.value.isNotEmpty) {
      result = result.where((room) {
        return room.name.toLowerCase().contains(currentSearch.value);
      }).toList();
    }

    filteredContactList.value = result;
  }

  Future<void> fetchLocations() async {
    final supabase = Supabase.instance.client;

    final response = await supabase.from('locations').select('name');

    final uniqueLocations = response
        .map<String>((row) => row['name'] as String)
        .toSet()
        .toList();

    locationList.value = uniqueLocations;
  }

  Future<void> fetchRooms() async {
    final supabase = Supabase.instance.client;

    final response = await supabase.from('live_chat_rooms').select();

    final rooms = response
        .map<Contact>((room) => Contact.fromJson(room))
        .toList();

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
              const PageHeader(title: 'Live Chat'),

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
                    ValueListenableBuilder<List<String>>(
                      valueListenable: locationList,
                      builder: (ctx, locations, _) {
                        return LocationFilterButton(
                          locations: locations,
                          selectedLocation: selectedLocation.value,
                          onLocationSelected: (loc) {
                            selectedLocation.value = loc;
                            applyFilters();
                          },
                        );
                      },
                    ),

                    const SizedBox(width: 15),

                    ValueListenableBuilder<List<String>>(
                      valueListenable: interestList,
                      builder: (ctx, interests, _) {
                        return InterestFilterButton(
                          interests: interests,
                          selectedInterest: selectedInterest.value,
                          onInterestSelected: (interest) {
                            selectedInterest.value = interest;
                            applyFilters();
                          },
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
                  child: ContactRoomList(roomListNotifier: filteredContactList),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 23, bottom: 17),
        child: AppFAB(
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
    );
  }
}
