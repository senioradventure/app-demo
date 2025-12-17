import 'package:flutter/material.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';
import 'package:senior_circle/theme/texttheme/text_theme.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.text, required this.time , required this.isMe});

  final String text;
  final String time;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
  
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: isMe ? EdgeInsets.symmetric(vertical: 2, horizontal: 12) : EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
                color: isMe ? AppColors.lightBlue : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              maxWidth: 280, 
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(text, style: AppTextTheme.lightTextTheme.bodyMedium),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: AppTextTheme.lightTextTheme.labelSmall?.copyWith(
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
      ),
      ],
    );
  }
}