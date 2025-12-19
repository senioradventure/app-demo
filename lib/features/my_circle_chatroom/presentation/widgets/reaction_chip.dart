import 'package:flutter/material.dart';
import 'package:senior_circle/core/constants/emojis/reaction_list.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/reaction_model.dart';

class ReactionChip extends StatelessWidget {
  final Reaction reaction;
  final VoidCallback? onTap;

  const ReactionChip({
    super.key,
    required this.reaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final emoji = ReactionList.getEmoji(reaction.name);

    return GestureDetector(
      onTap: onTap,
      child: Container(
         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.textLightGray),
              borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 6),
            Text(
              reaction.count.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
