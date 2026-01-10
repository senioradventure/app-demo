import 'package:flutter/material.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/empty_chat.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/linked_message.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/receiver_message_bubble.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/sender_message_bubble.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/user_bottom_sheet.dart';

class ChatMessageList extends StatelessWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final Function(String url) onOpenLink;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.onOpenLink,
  });

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const EmptyChatStateWidget();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    });

    return ListView.builder(
      controller: scrollController,
      reverse: true,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 0),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[messages.length - 1 - index];

        if (msg.isSender) {
          return SenderMessageBubble(
            msg: msg,
            buildMessageText: (context, msg) {
              return LinkedMessageText(
                text: msg.text,
                msg: msg,
                onPhoneTap: (phone, msg) {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (_) => UserProfileBottomSheet(
                      msg: msg,
                      otherUserId: msg.senderId!,
                    ),
                  );
                },
                onLinkTap: onOpenLink,
              );
            },
          );
        }

        return ReceiverMessageBubble(
          msg: msg,
          buildMessageText: (context, msg) {
            return LinkedMessageText(
              text: msg.text,
              msg: msg,
              onPhoneTap: (phone, msg) {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => UserProfileBottomSheet(
                    msg: msg,
                    otherUserId: msg.senderId!,
                  ),
                );
              },
              onLinkTap: onOpenLink,
            );
          },
        );
      },
    );
  }
}
