import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/common/widgets/image_mesage_bubble.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_bloc.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_event.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_message_type.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/reaction_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_actions.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_replies.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';

class GroupMessageCard extends StatefulWidget {
  final GroupMessage grpmessage;
  final bool isReply;
  final bool isContinuation;

  const GroupMessageCard({
    super.key,
    required this.grpmessage,
    this.isReply = false,
    this.isContinuation = false,
  });

  @override
  State<GroupMessageCard> createState() => _GroupMessageCardState();
}

class _GroupMessageCardState extends State<GroupMessageCard> {
  final TextEditingController _replyController = TextEditingController();

  void _onReactionTap(BuildContext context, String emoji) {
    context.read<ChatBloc>().add(
      ToggleReaction(
        messageId: widget.grpmessage.id,
        emoji: emoji,
        userId: 'you',
        type: ChatMessageType.group,
      ),
    );
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return EmojiPicker(
          onEmojiSelected: (category, emoji) {
            _onReactionTap(context, emoji.emoji);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final grpmessage = widget.grpmessage;
    final likeReaction = grpmessage.reactions
        .where((r) => r.emoji == '👍')
        .toList();

    final likeCount = likeReaction.isNotEmpty ? likeReaction.first.count : 0;

    final isLiked =
        likeReaction.isNotEmpty && likeReaction.first.userIds.contains('you');

    return Container(
      margin: EdgeInsets.only(
       // top: widget.isContinuation || widget.isReply ? 0 : 4,
        bottom: widget.isContinuation || widget.isReply ? 0 : 6,
      ),
      decoration: BoxDecoration(
        color: grpmessage.senderName.toLowerCase() == 'you'
            ? const Color(0xFFF9EFDB)
            : AppColors.white,
        border: widget.isReply
            ? null
            : Border(
                left: BorderSide(color: AppColors.borderColor),
                right: BorderSide(color: AppColors.borderColor),
                bottom: BorderSide(color: AppColors.borderColor),
                top: widget.isContinuation
                    ? BorderSide.none
                   : BorderSide(color: AppColors.borderColor),
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(grpmessage.avatar ?? ''),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(grpmessage),

                  if (grpmessage.imagePath != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: ImageMessageBubble(
                        imagePath: grpmessage.imagePath!,
                        isMe: grpmessage.senderName.toLowerCase() == 'you',
                        isGroup: true,
                      ),
                    ),

                  if (grpmessage.text != null && grpmessage.text!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Text(
                        grpmessage.text!,
                        style: AppTextTheme.lightTextTheme.bodyMedium,
                      ),
                    ),

                  MessageActions(
                    isLiked: isLiked,
                    likeCount: likeCount,
                    reactions: grpmessage.reactions,
                    onReactionTap: (emoji) => _onReactionTap(context, emoji),
                    onAddReactionTap: _showEmojiPicker,
                    onLikeTap: () => _onReactionTap(context, '👍'),
                    onReplyTap: () {
                      context.read<ChatBloc>().add(
                        ToggleReplyInput(messageId: grpmessage.id),
                      );
                    },

                    isReply: widget.isReply,
                  ),

                  if (grpmessage.replies.isNotEmpty)
                    _buildReplyButton(grpmessage),

                  if (grpmessage.isThreadOpen)
                    Column(
                      children: [
                        Divider(color: AppColors.lightGray),
                        MessageReplies(replies: grpmessage.replies),
                      ],
                    ),
                  if (grpmessage.isReplyInputOpen)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextField(
                        controller: _replyController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Write a reply...",
                          hintStyle: AppTextTheme.lightTextTheme.labelMedium,
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: AppColors.buttonBlue,
                            ),
                            onPressed: () {
                              if (_replyController.text.trim().isEmpty) return;

                              context.read<ChatBloc>().add(
                                AddGroupReply(
                                  parentMessageId: grpmessage.id,
                                  text: _replyController.text.trim(),
                                ),
                              );

                              _replyController.clear();

                              context.read<ChatBloc>().add(
                                ToggleReplyInput(messageId: grpmessage.id),
                              );
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: AppColors.borderColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(GroupMessage grpmessage) => Row(
    children: [
      Text(
        grpmessage.senderName,
        style: AppTextTheme.lightTextTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(width: 14),
      Text(
        grpmessage.time,
        style: AppTextTheme.lightTextTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );

  Widget _buildReplyButton(GroupMessage grpmessage) => Center(
    child: TextButton.icon(
      onPressed: () {
        context.read<ChatBloc>().add(
          ToggleGroupThread(messageId: grpmessage.id),
        );
      },

      label: Text(
        "${grpmessage.replies.length} Replies",
        style: TextStyle(
          color: grpmessage.isThreadOpen
              ? AppColors.textDarkGray
              : AppColors.buttonBlue,
        ),
      ),
      icon: Icon(
        grpmessage.isThreadOpen
            ? Icons.keyboard_arrow_up
            : Icons.keyboard_arrow_down,
        color: grpmessage.isThreadOpen
            ? AppColors.textDarkGray
            : AppColors.buttonBlue,
        size: 24,
      ),
      iconAlignment: IconAlignment.end,
    ),
  );
}
