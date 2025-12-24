import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/constants/strings/lists.dart';
import 'package:senior_circle/features/createroom/presentation/create_room_screen.dart';
import 'package:senior_circle/features/live_chat_home/presentation/bloc/live_chat_home_bloc.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/app_bar.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/contact_list.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/floating_button.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/interest_filter_button.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/location_filter_button.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/search_text_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LiveChatPage extends StatelessWidget {
  const LiveChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LiveChatHomeBloc()
        ..add(FetchLocationsEvent())
        ..add(FetchRoomsEvent()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F7),
        body: SafeArea(
          child: Container(
            color: const Color(0xFFF9F9F7),

            // FIX: All UI reacts to Bloc state
            child: BlocBuilder<LiveChatHomeBloc, LiveChatHomeState>(
              builder: (context, state) {
                return Column(
                  children: [
                    const PageHeader(title: 'Live Chat'),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 4,
                      ),
                      child: SearchTextField(
                        onChanged: (txt) {
                          context.read<LiveChatHomeBloc>().add(
                            UpdateSearchEvent(txt),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Row(
                        children: [
                          LocationFilterButton(
                            locations: state.locations,
                            selectedLocation: state.selectedLocation,
                            onLocationSelected: (locId) {
                              context.read<LiveChatHomeBloc>().add(
                                UpdateLocationFilterEvent(locId),
                              );
                            },
                          ),

                          const SizedBox(width: 15),

                          InterestFilterButton(
                            interests: AppLists.interests,
                            selectedInterest: state.selectedInterest,
                            onInterestSelected: (interest) {
                              context.read<LiveChatHomeBloc>().add(
                                UpdateInterestFilterEvent(interest),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child: Container(
                        color: Colors.white,

                        child: ContactRoomList(roomList: state.filteredRooms),
                      ),
                    ),
                  ],
                );
              },
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

              if (!context.mounted) return;

              if (result != null) {
                await Supabase.instance.client.from('live_chat_rooms').insert({
                  'name': result['roomName'],
                  'image_url': result['imageUrl'],
                  'interests': [],
                });

                if (!context.mounted) return;

                context.read<LiveChatHomeBloc>().add(FetchRoomsEvent());
              }
            },
          ),
        ),
      ),
    );
  }
}
