import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_bloc.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_state.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/message_action_dialog.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/user_bottom_sheet.dart';

class ReceiverMessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final Widget Function(BuildContext, ChatMessage) buildMessageText;
  final String currentUserId;

  const ReceiverMessageBubble({
    super.key,
    required this.msg,
    required this.buildMessageText,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final senderId = msg.senderId;
    if (senderId == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<ChatRoomBloc, ChatRoomState>(
                buildWhen: (prev, curr) =>
                    prev.userProfiles[senderId] != curr.userProfiles[senderId],
                builder: (context, state) {
                  final profile = state.userProfiles[senderId];

                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (_) => BlocProvider.value(
                          value: context.read<ChatRoomBloc>(),
                          child: UserProfileBottomSheet(
                            msg: msg,
                            otherUserId: senderId,
                            profile: profile,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage:
                          (profile?.avatarUrl != null &&
                              profile!.avatarUrl!.isNotEmpty)
                          ? NetworkImage(profile.avatarUrl!)
                          : const AssetImage('assets/images/chat_profile.png')
                                as ImageProvider,
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),

              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<ChatRoomBloc, ChatRoomState>(
                      buildWhen: (prev, curr) =>
                          prev.userProfiles[senderId] !=
                          curr.userProfiles[senderId],
                      builder: (context, state) {
                        final profile = state.userProfiles[senderId];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile?.fullName ?? 'User',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6A6A6A),
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        );
                      },
                    ),

                    GestureDetector(
                      onLongPress: () {
                        FocusScope.of(context).unfocus();

                        if (msg.id == null) return;

                        MessageActionDialog.show(
                          context,
                          messageId: msg.id!,
                          currentUserId: currentUserId,
                        );
                      },

                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth:
                              (msg.imageAsset != null || msg.imageFile != null)
                              ? MediaQuery.of(context).size.width * 0.66
                              : MediaQuery.of(context).size.width * 0.635,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (msg.imageAsset != null || msg.imageFile != null)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                          0.66,
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                          0.45,
                                    ),
                                    child: msg.imageFile != null
                                        ? (msg.imageFile!.startsWith('http')
                                              ? Image.network(
                                                  msg.imageFile!,
                                                  fit: BoxFit.contain,
                                                )
                                              : Image.file(
                                                  File(msg.imageFile!),
                                                  fit: BoxFit.contain,
                                                ))
                                        : Image.asset(
                                            msg.imageAsset!,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildMessageText(context, msg),
                                  const SizedBox(height: 2),
                                  Text(
                                    msg.time,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF777777),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
