import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/common/widgets/image_mesage_bubble.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_bloc.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_event.dart';
import 'package:senior_circle/core/enum/chat_message_type.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_actions.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_replies.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_header.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_reply_input.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroupMessageCard extends StatefulWidget {
  final GroupMessage grpmessage;
  final bool isReply;
  final bool isContinuation;
  final bool isLastInGroup;

  const GroupMessageCard({
    super.key,
    required this.grpmessage,
    this.isReply = false,
    this.isContinuation = false,
    this.isLastInGroup = false,
  });

  @override
  State<GroupMessageCard> createState() => _GroupMessageCardState();
}

class _GroupMessageCardState extends State<GroupMessageCard> {
  final TextEditingController _replyController = TextEditingController();

  void _onReactionTap(BuildContext context, String emoji) {
    final userId = Supabase.instance.client.auth.currentUser!.id;

    context.read<ChatBloc>().add(
      ToggleReaction(
        messageId: widget.grpmessage.id,
        emoji: emoji,
        userId: userId,
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

  void _handleStar() {
    context.read<ChatBloc>().add(
      ToggleStar(
        messageId: widget.grpmessage.id,
        userId: Supabase.instance.client.auth.currentUser!.id,
      ),
    );
  }

  void _handleForward() {
    debugPrint('Forward message: ${widget.grpmessage.id}');
  }

  void _handleShare() {
    debugPrint('Share message: ${widget.grpmessage.id}');
  }

  void _handleDeleteForMe() {
    context.read<ChatBloc>().add(
      DeleteGroupMessage(messageId: widget.grpmessage.id, forEveryone: false),
    );
  }

  void _handleDeleteForEveryone() {
    context.read<ChatBloc>().add(
      DeleteGroupMessage(messageId: widget.grpmessage.id, forEveryone: true),
    );
  }

  Future<void> _showContextMenu(
    BuildContext context,
    GroupMessage msg,
    bool isMe,
  ) async {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final menuWidth = MediaQuery.of(context).size.width * 0.7;
    final screenWidth = MediaQuery.of(context).size.width;

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "menu",
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            Positioned(
              top: offset.dy + box.size.height - 60,
              left: isMe ? (screenWidth - menuWidth) - 16 : 16,
              width: menuWidth,
              child: Material(
                color: Colors.white,
                elevation: 8,
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuItem(
                      context,
                      msg.isStarred ? 'UNSTAR' : 'STAR',
                      iconPath: 'assets/icons/star_icon.svg',
                      action: _handleStar,
                    ),
                    const PopupMenuDivider(),
                    _buildMenuItem(
                      context,
                      'FORWARD',
                      iconPath: 'assets/icons/forward_icon.svg',
                      action: _handleForward,
                    ),
                    const PopupMenuDivider(),
                    _buildMenuItem(
                      context,
                      'SHARE',
                      iconPath: 'assets/icons/share_icon.svg',
                      action: _handleShare,
                    ),
                    const PopupMenuDivider(),
                    _buildMenuItem(
                      context,
                      'DELETE FOR ME',
                      action: _handleDeleteForMe,
                    ),
                    if (isMe) ...[
                      const PopupMenuDivider(),
                      _buildMenuItem(
                        context,
                        'DELETE FOR EVERYONE',
                        action: _handleDeleteForEveryone,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  PopupMenuEntry _buildMenuItem(
    BuildContext context,
    String title, {
    String? iconPath,
    required VoidCallback action,
  }) {
    return PopupMenuItem(
      value: title,
      onTap: action,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconPath != null)
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: SvgPicture.asset(iconPath),
            ),
          Text(title, style: AppTextTheme.lightTextTheme.labelMedium),
        ],
      ),
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
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final isMe = currentUserId != null && grpmessage.senderId == currentUserId;
    final likeReaction = grpmessage.reactions
        .where((r) => r.emoji == '👍')
        .toList();

    final likeCount = likeReaction.isNotEmpty ? likeReaction.first.count : 0;

    final isLiked =
        likeReaction.isNotEmpty &&
        likeReaction.first.userIds.contains(currentUserId);

    final BoxBorder? customBorder = widget.isReply
        ? null
        : Border(
            left: BorderSide(color: AppColors.borderColor),
            right: BorderSide(color: AppColors.borderColor),
            top: widget.isContinuation
                ? BorderSide.none
                : BorderSide(color: AppColors.borderColor),
            bottom: widget.isLastInGroup
                ? BorderSide(color: AppColors.borderColor)
                : BorderSide.none,
          );

    return Builder(
      builder: (context) {
        return GestureDetector(
          onLongPress: () => _showContextMenu(context, grpmessage, isMe),
          child: Container(
            margin: EdgeInsets.only(
              bottom: widget.isLastInGroup && !widget.isReply ? 6 : 0,
            ),
            decoration: BoxDecoration(
              border: widget.isContinuation || widget.isReply
                  ? null
                  : customBorder,
            ),
            child: Column(
              children: [
                Container(
                  color: isMe ? const Color(0xFFF9EFDB) : AppColors.white,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: widget.isContinuation ? 8 : 12,
                      bottom: widget.isLastInGroup ? 8 : 2,
                      left: 12,
                      right: 12,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage: grpmessage.avatar != null
                              ? NetworkImage(grpmessage.avatar!)
                              : null,
                          backgroundColor: AppColors.borderColor,
                          child: grpmessage.avatar == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GroupMessageHeader(
                                grpmessage: grpmessage,
                                isMe: isMe,
                              ),

                              if (grpmessage.imagePath != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    bottom: 4,
                                  ),
                                  child: ImageMessageBubble(
                                    imagePath: grpmessage.imagePath!,
                                    isMe: isMe,

                                    isGroup: true,
                                  ),
                                ),

                              if (grpmessage.text != null &&
                                  grpmessage.text!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 4,
                                    bottom: 4,
                                  ),
                                  child: Text(
                                    grpmessage.text!,
                                    style:
                                        AppTextTheme.lightTextTheme.bodyMedium,
                                  ),
                                ),

                              MessageActions(
                                isLiked: isLiked,
                                likeCount: likeCount,
                                reactions: grpmessage.reactions,
                                onReactionTap: (emoji) =>
                                    _onReactionTap(context, emoji),
                                isReplyInputVisible:
                                    grpmessage.isReplyInputOpen,

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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (grpmessage.isThreadOpen)
                  MessageReplies(replies: grpmessage.replies),

                if (grpmessage.isReplyInputOpen)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 33,
                      right: 12,
                      bottom: 12,
                    ),
                    child: BuildReplyInputField(
                      replyController: _replyController,
                      grpmessage: grpmessage,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

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
          fontSize: 12,
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
        size: 20,
      ),
      iconAlignment: IconAlignment.end,
    ),
  );
}
