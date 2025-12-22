import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:senior_circle/core/common/widgets/image_mesage_bubble.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';
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
  bool _isLiked = false;
  bool _isReplyInputVisible = false;
  late int _likeCount;
  late Map<String, int> _reactionCounts;
  late Set<String> _selectedReactions;

  List<Reaction> _buildReactionList() {
    return widget.grpmessage.reactions.map((r) {
      return Reaction(emoji: r.emoji, userIds: r.userIds);
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    final likeReaction = widget.grpmessage.reactions
        .where((r) => r.emoji == '👍')
        .toList();

    _likeCount = likeReaction.isNotEmpty ? likeReaction.first.count : 0;

    _reactionCounts = {
      for (final r in widget.grpmessage.reactions)
        if (r.emoji != '👍') r.emoji: r.count,
    };

    const currentUserId = 'you';

    _selectedReactions = {
      for (final r in widget.grpmessage.reactions)
        if (r.userIds.contains(currentUserId)) r.emoji,
    };
  }

  void _onReactionTap(String emoji) {
    setState(() {
      final userId = 'you';

      final existing = widget.grpmessage.reactions
          .where((r) => r.emoji == emoji)
          .toList();

      if (existing.isNotEmpty) {
        final reaction = existing.first;

        if (reaction.userIds.contains(userId)) {
          reaction.userIds.remove(userId);
          if (reaction.userIds.isEmpty) {
            widget.grpmessage.reactions.remove(reaction);
          }
        } else {
          reaction.userIds.add(userId);
        }
      } else {
        widget.grpmessage.reactions.add(
          Reaction(emoji: emoji, userIds: [userId]),
        );
      }
    });
  }

  void _handleLike() {
    setState(() {
      if (_isLiked) {
        _likeCount -= 1;
      } else {
        _likeCount += 1;
      }
      _isLiked = !_isLiked;
    });
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return EmojiPicker(
          onEmojiSelected: (category, emoji) {
            _onReactionTap(emoji.emoji);
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

    return Container(
      margin: EdgeInsets.only(
        top: widget.isContinuation || widget.isReply ? 0 : 4,
        bottom: widget.isContinuation || widget.isReply ? 0 : 4,
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
                    isLiked: _isLiked,
                    onReactionTap: _onReactionTap,
                    onAddReactionTap: _showEmojiPicker,
                    likeCount: _likeCount,
                    onLikeTap: _handleLike,
                    onReplyTap: () => setState(
                      () => _isReplyInputVisible = !_isReplyInputVisible,
                    ),
                    isReplyInputVisible: _isReplyInputVisible,
                    isReply: widget.isReply,
                    reactions: _buildReactionList(),
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
                  if (_isReplyInputVisible)
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
                              if (_replyController.text.trim().isNotEmpty) {
                                setState(() {
                                  grpmessage.replies.add(
                                    GroupMessage(
                                      senderName: "You",
                                      text: _replyController.text.trim(),
                                      time: "Just now",
                                      avatar: "",
                                      replies: [],
                                      id: '',
                                      senderId: '',
                                    ),
                                  );
                                  _isReplyInputVisible = false;
                                  _replyController.clear();
                                  grpmessage.isThreadOpen = true;
                                });
                              }
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
      onPressed: () =>
          setState(() => grpmessage.isThreadOpen = !grpmessage.isThreadOpen),
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
