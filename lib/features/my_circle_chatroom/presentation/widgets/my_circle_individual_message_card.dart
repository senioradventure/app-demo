import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';
import 'package:senior_circle/core/common/widgets/message_bubble.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/reaction_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/reaction_bar.dart';

class IndividualMessageCard extends StatelessWidget {
  final Message message;
  

  const IndividualMessageCard({
    super.key,
    required this.message,
 
  });

  bool get isMe => message.sender.toLowerCase() == 'you';

  void _openEmojiPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return SizedBox(
          height: 350,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              Navigator.pop(context);
              _handleReaction(emoji);
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

  void _handleReaction(Emoji emoji) {
    debugPrint('Reacted with $emoji on message ${message.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return GestureDetector(
          onLongPress: () {
            _showContextMenu(context, message);
          },
          child: MessageBubble(
            text: message.text,
            time: message.time,
            isMe: isMe,
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

    reactionOverlay = OverlayEntry(
      builder: (_) => Positioned(
        left: isMe ? (screenWidth - menuWidth) : 16,
        top: offset.dy - reactionBarHeight - 36,
        child: ReactionBar(
          onAddTap: () {
            reactionOverlay.remove();
            Navigator.pop(context);
            _openEmojiPicker(context);
          },
          onReactionTap: (emoji) {
            reactionOverlay.remove();
            Navigator.pop(context);
           _handleReaction(emoji);
          },
        ),
      ),
    );

    overlay.insert(reactionOverlay);

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
    reactionOverlay.remove();
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
