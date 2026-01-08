import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/common/widgets/common_app_bar.dart';
import 'package:senior_circle/core/common/widgets/search_bar_widget.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/individual_chat/bloc/individual_chat_bloc.dart';
import 'package:senior_circle/features/individual_chat/presentation/my_circle_individual_chat_page.dart';
import 'package:senior_circle/features/individual_chat/repositories/individual_chat_repository.dart';
import 'package:senior_circle/features/view_friends/bloc/view_friends_bloc.dart';
import 'package:senior_circle/features/view_friends/bloc/view_friends_event.dart';
import 'package:senior_circle/features/view_friends/bloc/view_friends_state.dart';
import 'package:senior_circle/features/view_friends/presentation/widgets/friend_tile_widget.dart';

class ViewFriendsPage extends StatelessWidget {
  const ViewFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Friends'),

      /// 🔥 LISTENER HANDLES NAVIGATION
      body: BlocListener<ViewFriendsBloc, ViewFriendsState>(
        listener: (context, state) {
          if (state is ViewFriendsNavigateToChat) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) =>
                      IndividualChatBloc(IndividualChatRepository())
                        ..add(LoadConversationMessages(state.chat.id)),
                  child: MyCircleIndividualChatPage(chat: state.chat),
                ),
              ),
            );
          }
        },

        /// 🔹 EXISTING UI
        child: Column(
          children: [
            const SizedBox(height: 12),

            SearchBarWidget(
              hintText: 'Search Friends',
              onChanged: (value) {
                context.read<ViewFriendsBloc>().add(SearchFriends(value));
              },
            ),

            const SizedBox(height: 12),

            Expanded(
              child: BlocBuilder<ViewFriendsBloc, ViewFriendsState>(
                builder: (context, state) {
                  if (state is ViewFriendsLoading ||
                      state is ViewFriendsInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ViewFriendsLoaded) {
                    if (state.friends.isEmpty) {
                      return const Center(child: Text('No friends found'));
                    }

                    return ListView.separated(
                      itemCount: state.friends.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: AppColors.borderColor, height: 1),
                      itemBuilder: (context, index) {
                        return FriendTile(friend: state.friends[index]);
                      },
                    );
                  }

                  if (state is ViewFriendsError) {
                    return Center(child: Text(state.message));
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
