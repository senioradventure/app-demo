import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MessageReplies extends StatelessWidget {
  final List<GroupMessage> replies;

  const MessageReplies({super.key, required this.replies});

  @override
  Widget build(BuildContext context) {
    if (replies.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        const Divider(color: AppColors.borderColor, thickness: 1, height: 0),
        Padding(
          padding: EdgeInsetsGeometry.only(
            left: 36,
            bottom: 8,
            top: 8,
          ),
          child: Column(
            children: List.generate(replies.length, (index) {
              final currentUserId = Supabase.instance.client.auth.currentUser?.id;
              final isMe = currentUserId != null && replies[index].senderId == currentUserId;
              final currentReply = replies[index];
              final bool isContinuation = index > 0 && replies[index - 1].senderId == currentReply.senderId;
              return Container(
                color: isMe
                    ? const Color(0xFFF9EFDB)
                    : AppColors.white,
                padding: const EdgeInsets.only(right: 12),
                child: GroupMessageCard(
                  key: ValueKey(currentReply.id),
                  grpmessage: currentReply,
                  isReply: true,
                  isContinuation: isContinuation,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
