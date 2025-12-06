import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';
import 'package:senior_circle/theme/texttheme/text_theme.dart';

class MessageActions extends StatelessWidget {
  final VoidCallback onReplyTap;

  const MessageActions({super.key, required this.onReplyTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            width: MediaQuery.of(context).size.width * 0.1,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.textLightGray),
              borderRadius: BorderRadius.circular(24),
            ),
            child: SvgPicture.asset('assets/icons/like_button.svg'),
          ),
        ),

        IconButton(
          icon: const Icon(Icons.add_circle),
          color: const Color(0xFF5c5c5c),
          onPressed: () {},
          iconSize: 28,
        ),

        const Spacer(),
        TextButton.icon(
          onPressed: onReplyTap,
          icon: SvgPicture.asset('assets/icons/reply_icon.svg'),
          label: Text(
            "Reply",
            style: AppTextTheme.lightTextTheme.labelMedium?.copyWith(
              color: AppColors.textDarkGray,
            ),
          ),
        ),
      ],
    );
  }
}
