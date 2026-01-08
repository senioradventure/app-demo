import 'package:flutter/material.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/empty_chat.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/linked_message.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/sender_message_bubble.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/receiver_message_bubble.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/user_bottom_sheet.dart';

class ChatMessageList extends StatelessWidget {
  final Stream<List<Map<String, dynamic>>> messagesStream;
  final List<ChatMessage> optimisticMessages;
  final String currentUserId;
  final ScrollController scrollController;
  final Function(String url) onOpenLink;

  const ChatMessageList({
    super.key,
    required this.messagesStream,
    required this.optimisticMessages,
    required this.currentUserId,
    required this.scrollController,
    required this.onOpenLink,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: messagesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messagesData = List<Map<String, dynamic>>.from(snapshot.data!);

        messagesData.sort(
          (a, b) => DateTime.parse(
            a['created_at'],
          ).compareTo(DateTime.parse(b['created_at'])),
        );

        if (messagesData.isEmpty && optimisticMessages.isEmpty) {
          return const EmptyChatStateWidget();
        }

        final messages = messagesData
            .map((data) => ChatMessage.fromMap(data, currentUserId))
            .toList();

        final streamIds = messages.map((m) => m.id).toSet();
        final pendingOptimistic = optimisticMessages
            .where((m) => !streamIds.contains(m.id))
            .toList();

        messages.addAll(pendingOptimistic);

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
                        builder: (_) => UserProfileBottomSheet(msg: msg),
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
                      builder: (_) => UserProfileBottomSheet(msg: msg),
                    );
                  },
                  onLinkTap: onOpenLink,
                );
              },
            );
          },
        );
      },
    );
  }
}
