import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';

class MessageActions extends StatelessWidget {
  final VoidCallback onReplyTap;
  final VoidCallback onLikeTap;
  final bool isReply;
  final bool isReplyInputVisible;
  final bool isLiked;
  final int likeCount;

  const MessageActions({
    super.key,
    required this.onReplyTap,
    required this.onLikeTap,
    this.isReply = false,
    this.isReplyInputVisible = false,
    this.isLiked = false,
    this.likeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Updated Like/Reaction Section
        GestureDetector(
          onTap: onLikeTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.textLightGray),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  isLiked
                      ? 'assets/icons/liked_icon.svg'
                      : 'assets/icons/like_button.svg',
                ),
                const SizedBox(width: 6),
                // Displaying name and count
                Text(
                  "${likeCount > 0 ? likeCount : ''}",
                  style: AppTextTheme.lightTextTheme.labelSmall?.copyWith(
                    color: isLiked
                        ? AppColors.buttonBlue
                        : AppColors.textDarkGray,
                    fontWeight: isLiked ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),

        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          color: const Color(0xFF5c5c5c),
          onPressed: () {
            // Show emoji picker logic here
          },
          iconSize: 24,
        ),

        const Spacer(),

        if (!isReply)
          TextButton.icon(
            onPressed: onReplyTap,
            icon: SvgPicture.asset(
              'assets/icons/reply_icon.svg',
              colorFilter: ColorFilter.mode(
                isReplyInputVisible
                    ? AppColors.buttonBlue
                    : AppColors.textDarkGray,
                BlendMode.srcIn,
              ),
            ),
            label: Text(
              "Reply",
              style: AppTextTheme.lightTextTheme.labelMedium?.copyWith(
                color: isReplyInputVisible
                    ? AppColors.buttonBlue
                    : AppColors.textDarkGray,
              ),
            ),
          ),
      ],
    );
  }
}
