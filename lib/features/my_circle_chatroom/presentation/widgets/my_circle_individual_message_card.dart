import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_circle/core/common/widgets/image_mesage_bubble.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';
import 'package:senior_circle/core/common/widgets/message_bubble.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_bloc.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_event.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_message_type.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/reaction_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/reaction_bar.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/reaction_chip.dart';

class IndividualMessageCard extends StatelessWidget {
  final Message message;

  const IndividualMessageCard({super.key, required this.message});

  bool get isMe => message.senderId.toLowerCase() == 'you';

  void _openEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.45,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              Navigator.pop(context);
              _handleReaction(context, emoji.emoji);
            },
          ),
        );
      },
    );
  }

  void _handleStar() {
    debugPrint('Starred message: ${message.id}');
  }

  void _handleForward() {
    debugPrint('Forward message: ${message.id}');
  }

  void _handleShare() {
    debugPrint('Share message: ${message.id}');
  }

  void _handleDeleteForMe() {
    debugPrint('Delete for me: ${message.id}');
  }

  void _handleDeleteForEveryone() {
    debugPrint('Delete for everyone: ${message.id}');
  }

  void _handleReaction(BuildContext context, String emoji) {
    context.read<ChatBloc>().add(
      ToggleReaction(messageId: message.id, emoji: emoji, userId: 'you', type: ChatMessageType.individual,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onLongPress: () {
            _showContextMenu(context, message);
          },
          child: Column(
            crossAxisAlignment: isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (message.isImage)
                ImageMessageBubble(imagePath: message.imagePath!, isMe: isMe , isGroup: false,)
              else if (message.isText)
                MessageBubble(
                  text: message.text!,
                  time: message.time,
                  isMe: isMe,
                ),

              if (message.reactions.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Wrap(
                    spacing: 6,
                    children: message.reactions.entries.map((entry) {
                      final reaction = Reaction(
                        emoji: entry.key,
                        userIds: entry.value,
                      );

                      return ReactionChip(
                        reaction: reaction,
                        onTap: () {
                          context.read<ChatBloc>().add(
                            ToggleReaction(
                              messageId: message.id,
                              emoji: reaction.emoji,
                              userId: 'you', type: ChatMessageType.individual,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showContextMenu(BuildContext context, Message msg) async {
    final overlay = Overlay.of(context);

    final box = context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset.zero);

    const reactionBarHeight = 47.0;

    final menuWidth = MediaQuery.of(context).size.width * 0.7;
    final screenWidth = MediaQuery.of(context).size.width;

    late OverlayEntry reactionOverlay;
    bool overlayRemoved = false;

    void removeReactionOverlay() {
      if (!overlayRemoved && reactionOverlay.mounted) {
        reactionOverlay.remove();
        overlayRemoved = true;
      }
    }

    reactionOverlay = OverlayEntry(
      builder: (_) => Positioned(
        left: isMe ? (screenWidth - menuWidth) : 16,
        top: offset.dy - reactionBarHeight - 36,
        child: ReactionBar(
          onAddTap: () {
            removeReactionOverlay();

            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            Future.microtask(() {
              if (!context.mounted) return;
              _openEmojiPicker(context);
            });
          },

          onReactionTap: (emoji) {
            removeReactionOverlay();

            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }

            Future.microtask(() {
              if (!context.mounted) return;
              _handleReaction(context, emoji);
            });
          },
        ),
      ),
    );

    overlay.insert(reactionOverlay);

    try {
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
                        'STAR',
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
                      const PopupMenuDivider(),
                      _buildMenuItem(
                        context,
                        'DELETE FOR EVERYONE',
                        action: _handleDeleteForEveryone,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    } finally {
      removeReactionOverlay();
    }
  }

  PopupMenuEntry _buildMenuItem(
    BuildContext context,
    String title, {
    String? iconPath,
    required VoidCallback action,
  }) {
    return PopupMenuItem(
      value: title,
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
      onTap: () {
        action();
      },
    );
  }
}
