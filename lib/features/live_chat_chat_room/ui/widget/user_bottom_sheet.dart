import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';

class UserProfileBottomSheet extends StatefulWidget {
  final ChatMessage msg;
  final String otherUserId; 

  const UserProfileBottomSheet({
    super.key,
    required this.msg,
    required this.otherUserId,
  });

  @override
  State<UserProfileBottomSheet> createState() =>
      _UserProfileBottomSheetState();
}

class _UserProfileBottomSheetState extends State<UserProfileBottomSheet> {
  final supabase = Supabase.instance.client;

  late final String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = supabase.auth.currentUser!.id;
  }

  Future<Map<String, dynamic>?> getFriendRequest() async {
    return await supabase
        .from('friend_requests')
        .select()
        .or(
          'and(sender_id.eq.$currentUserId,receiver_id.eq.${widget.otherUserId}),'
          'and(sender_id.eq.${widget.otherUserId},receiver_id.eq.$currentUserId)',
        )
        .maybeSingle();
  }

  Future<void> sendFriendRequest() async {
    await supabase.from('friend_requests').insert({
      'sender_id': currentUserId,
      'receiver_id': widget.otherUserId,
      'status': 'pending',
    });
    setState(() {});
  }

  Future<void> removeFriend() async {
    await supabase
        .from('friend_requests')
        .delete()
        .or(
          'and(sender_id.eq.$currentUserId,receiver_id.eq.${widget.otherUserId}),'
          'and(sender_id.eq.${widget.otherUserId},receiver_id.eq.$currentUserId)',
        );
    setState(() {});
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
      child: Align(
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
                      CircleAvatar(
                        radius: 45,
                        backgroundImage: avatarImage,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        msg.name ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
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
                          style: TextStyle(fontSize: 12,color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),


                FutureBuilder<Map<String, dynamic>?>(
                  future: getFriendRequest(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return _addFriendButton();
                    }

                    final request = snapshot.data!;

                    if (request['status'] == 'pending') {
                      final isSender =
                          request['sender_id'] == currentUserId;

                      return _bottomContainer(
                        isSender
                            ? "WAITING FOR APPROVAL"
                            : "RESPOND IN NOTIFICATIONS",
                        Colors.black,
                      );
                    }

                    if (request['status'] == 'accepted') {
                      return _friendActions();
                    }

                    return _addFriendButton();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _friendActions() {
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
              onTap: () async {
                await removeFriend();
                Navigator.pop(context);
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
          ),const VerticalDivider(
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
      onTap: sendFriendRequest,
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
