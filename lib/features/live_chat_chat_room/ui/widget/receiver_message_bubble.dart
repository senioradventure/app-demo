import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/message_action_dialog.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/user_bottom_sheet.dart';

class ReceiverMessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final Widget Function(BuildContext, ChatMessage) buildMessageText;

  const ReceiverMessageBubble({
    super.key,
    required this.msg,
    required this.buildMessageText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (msg.profileAsset != null) ...[
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => UserProfileBottomSheet(msg: msg,otherUserId: msg.senderId!,),
                    );
                  },
                  child: CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage(msg.profileAsset!),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (msg.name != null) ...[
                      Text(
                        msg.name!,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6A6A6A),
                        ),
                      ),
                      const SizedBox(height: 9),
                    ],
                    GestureDetector(
                      onLongPress: () {
                        FocusScope.of(context).unfocus();
                        MessageActionDialog.show(context);
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
