import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';
import 'package:senior_circle/core/common/widgets/message_bubble.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/message_model.dart';

class IndividualMessageCard extends StatelessWidget {
  final Message message;
  final Function(String action, Message message) onAction;

  const IndividualMessageCard( {
    super.key,
    required this.message,
    required this.onAction,
  });

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
            isMe: message.sender == 'You',
          ),
        );
      },
    );
  }

  void _showContextMenu(BuildContext context, Message msg) async {
    final RenderBox messageBox = context.findRenderObject() as RenderBox;
    final Offset position = messageBox.localToGlobal(Offset.zero);

    final RelativeRect positionRect = RelativeRect.fromLTRB(
      position.dx + messageBox.size.width / 2,
      position.dy + messageBox.size.height + 4,
      MediaQuery.of(context).size.width,
      0,
    );

    await showMenu(
      context: context,
      position: positionRect,
      items: <PopupMenuEntry>[
        _buildMenuItem(context, 'STAR', iconPath: 'assets/icons/star_icon.svg'),
        const PopupMenuDivider(),
        _buildMenuItem(
          context,
          'FORWARD',
          iconPath: 'assets/icons/forward_icon.svg',
        ),
        const PopupMenuDivider(),
        _buildMenuItem(
          context,
          'SHARE',
          iconPath: 'assets/icons/share_icon.svg',
        ),
        const PopupMenuDivider(),
        _buildMenuItem(context, 'DELETE FOR ME'),
        const PopupMenuDivider(),
        _buildMenuItem(context, 'DELETE FOR EVERYONE'),
      ],
      elevation: 8.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    );
  }

  PopupMenuEntry _buildMenuItem(
    BuildContext context,
    String title, {
    String? iconPath,
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
        Navigator.pop(context);
      },
    );
  }
}
