import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_bloc.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_event.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_state.dart';

class UserProfileBottomSheet extends StatefulWidget {
  final ChatMessage msg;
  final String otherUserId;

  const UserProfileBottomSheet({
    super.key,
    required this.msg,
    required this.otherUserId,
  });

  @override
  State<UserProfileBottomSheet> createState() => _UserProfileBottomSheetState();
}

class _UserProfileBottomSheetState extends State<UserProfileBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    final bloc = context.read<ChatRoomBloc>();
    bloc.add(FriendStatusRequested(widget.otherUserId));
    bloc.add(UserProfileRequested(widget.otherUserId)); 
  });
  }

  @override
  Widget build(BuildContext context) {
    final msg = widget.msg;

    final ImageProvider avatarImage =
        (msg.profileAsset != null && msg.profileAsset!.isNotEmpty)
        ? AssetImage(msg.profileAsset!)
        : const AssetImage('assets/images/chat_profile.png');

    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(color: Colors.transparent),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CircleAvatar(radius: 45, backgroundImage: avatarImage),
                        const SizedBox(height: 10),
                        Text(
                          msg.name ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F1F1),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Text(
                            "From Malappuram",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),

                  BlocBuilder<ChatRoomBloc, ChatRoomState>(
                    builder: (context, state) {
                      switch (state.friendStatus) {
                        case FriendStatus.loading:
                          return _bottomContainer("LOADING...", Colors.grey);

                        case FriendStatus.none:
                          return _addFriendButton();

                        case FriendStatus.pendingSent:
                          return _bottomContainer(
                            "WAITING FOR APPROVAL",
                            Colors.black,
                          );

                        case FriendStatus.pendingReceived:
                          return _bottomContainer(
                            "RESPOND IN NOTIFICATIONS",
                            Colors.black,
                          );

                        case FriendStatus.accepted:
                          return _friendActions(state.friendRequestId!);

                        default:
                          return _addFriendButton();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _friendActions(String requestId) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F7),
        border: Border(top: BorderSide(color: Color(0xFFE3E3E3))),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                context.read<ChatRoomBloc>().add(
                  FriendRemoveRequested(requestId),
                );
              },
              child: const Center(
                child: Text(
                  'REMOVE FRIEND',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: Color(0xFFE3E3E3),
          ),
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: const Center(
                child: Text(
                  'MESSAGE',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addFriendButton() {
    return InkWell(
      onTap: () {
        context.read<ChatRoomBloc>().add(FriendRequestSent(widget.otherUserId));
      },

      child: _bottomContainer("ADD FRIEND", Colors.blue),
    );
  }

  Widget _bottomContainer(String text, Color color) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F7),
        border: Border(top: BorderSide(color: Color(0xFFE3E3E3))),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w600, color: color),
        ),
      ),
    );
  }
}
