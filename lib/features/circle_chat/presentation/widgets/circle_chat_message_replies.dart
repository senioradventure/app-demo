import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/circle_chat/models/circle_chat_message_model.dart';
import 'package:senior_circle/features/circle_chat/presentation/widgets/circle_chat_message_card.dart';
import 'package:senior_circle/features/circle_chat/bloc/circle_chat_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CircleChatMessageReplies extends StatelessWidget {
  final List<CircleChatMessage> replies;

  const CircleChatMessageReplies({super.key, required this.replies});

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
              final currentUserId = context.read<CircleChatBloc>().repository.currentUserId;
              final isMe = currentUserId != null && replies[index].senderId == currentUserId;
              final currentReply = replies[index];
              final bool isContinuation = index > 0 && replies[index - 1].senderId == currentReply.senderId;
              return Container(
                color: isMe
                    ? const Color(0xFFF9EFDB)
                    : AppColors.white,
                padding: const EdgeInsets.only(right: 12),
                child: CircleChatMessageCard(
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
