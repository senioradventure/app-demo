import 'dart:io';

import 'package:flutter/material.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/message_action_dialog.dart';

class SenderMessageBubble extends StatelessWidget {
  final ChatMessage msg;
  final Widget Function(BuildContext, ChatMessage) buildMessageText;
  final String currentUserId;

  const SenderMessageBubble({
    super.key,
    required this.msg,
    required this.buildMessageText,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, right: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
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
              maxWidth: (msg.imageAsset != null || msg.imageFile != null)
                  ? MediaQuery.of(context).size.width * 0.66
                  : MediaQuery.of(context).size.width * 0.635,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFD6E6FF),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (msg.imageAsset != null || msg.imageFile != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width * 0.66,
                          maxHeight:
                              MediaQuery.of(context).size.height * 0.45,
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
                if (msg.text.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  buildMessageText(context, msg),
                ],
                const SizedBox(height: 4),
                Text(
                  msg.time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
