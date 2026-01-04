import 'package:flutter/material.dart';
import 'package:senior_circle/features/auth/presentation/friend%20request/friend_request.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
class UserProfileBottomSheet extends StatefulWidget {
  final ChatMessage msg;

  const UserProfileBottomSheet({
    super.key,
    required this.msg,
  });

  @override
  State<UserProfileBottomSheet> createState() =>
      _UserProfileBottomSheetState();
}

class _UserProfileBottomSheetState extends State<UserProfileBottomSheet> {
  final ValueNotifier<bool> isRequestSent = ValueNotifier(false);

  @override
  void dispose() {
    isRequestSent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final msg = widget.msg;

    final ImageProvider avatarImage =
        (msg.profileAsset != null && msg.profileAsset!.isNotEmpty)
            ? AssetImage(msg.profileAsset!)
            : const AssetImage('assets/images/chat_profile.png');

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.pop(context),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {},
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
                        padding: const EdgeInsets.only(
                          left: 24,
                          top: 20,
                          right: 24,
                          bottom: 15,
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const AllUsersWithFriendStatusPage(),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: avatarImage,
                              ),
                            ),
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
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF555555),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (msg.isFriend)
                        _friendActions()
                      else
                        _addFriendButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _friendActions() {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFFF9F9F7),
        border: Border(
          top: BorderSide(color: Color(0xFFE3E3E3)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'REMOVE FRIEND',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'MESSAGE',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addFriendButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: isRequestSent,
      builder: (_, sent, __) {
        return InkWell(
          onTap: () {
            if (!sent) isRequestSent.value = true;
          },
          child: Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFF9F9F7),
              border: Border(
                top: BorderSide(color: Color(0xFFE3E3E3)),
              ),
            ),
            child: Center(
              child: Text(
                sent ? "WAITING FOR APPROVAL" : "ADD FRIEND",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: sent ? Colors.black : Colors.blue,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
