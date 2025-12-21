import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_circle/core/constants/reactions.dart';

class ReactionBar extends StatelessWidget {
  final void Function(String emoji) onReactionTap;
  final VoidCallback onAddTap;

  const ReactionBar({
    super.key,
    required this.onReactionTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...defaultReactions.map(
              (emoji) => GestureDetector(
                onTap: () => onReactionTap(emoji),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onAddTap,
              child: SvgPicture.asset('assets/icons/add_reaction_icon.svg'),
            ),
          ],
        ),
      ),
    );
  }
}
