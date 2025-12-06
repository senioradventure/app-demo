import 'package:flutter/material.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';

class InterestChip extends StatelessWidget {
  final String label;
  final VoidCallback? onRemove;

  const InterestChip({super.key, required this.label, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 33,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(width: 6),

          // Delete Button
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 18,
              weight: 2,
              color: AppColors.iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
