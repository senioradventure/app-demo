import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/common/widgets/profile_aware_appbar.dart';
import 'package:senior_circle/core/constants/strings/lists.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/createroom/presentation/create_room_screen.dart';
import 'package:senior_circle/features/live_chat_home/presentation/bloc/live_chat_home_bloc.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/common_page_header.dart';
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
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: ProfileAwareAppBar(title: 'Live Chat',),
      body: SafeArea(
        child: BlocBuilder<LiveChatHomeBloc, LiveChatHomeState>(
          builder: (context, state) {
            return Column(
              children: [
               
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
    );
  }
}
