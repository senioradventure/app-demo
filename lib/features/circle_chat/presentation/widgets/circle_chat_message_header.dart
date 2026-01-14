import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';
import 'package:senior_circle/core/utils/time_utils.dart';
import 'package:senior_circle/features/circle_chat/models/circle_chat_message_model.dart';

class CircleChatMessageHeader extends StatelessWidget {
  final CircleChatMessage grpmessage;
  final bool isMe;

  const CircleChatMessageHeader({
    super.key,
    required this.grpmessage,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          isMe ? 'You' : grpmessage.senderName,
          style: AppTextTheme.lightTextTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          TimeUtils.formatTimeString(grpmessage.time),
          style: AppTextTheme.lightTextTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (grpmessage.isStarred) ...[
          const SizedBox(width: 8),
          SvgPicture.asset(
            'assets/icons/star_icon.svg',
            height: 12,
            width: 12,
            colorFilter: const ColorFilter.mode(
              Color(0xFFFFC107), // Amber/Gold
              BlendMode.srcIn,
            ),
          ),
        ],
      ],
    );
  }
}
