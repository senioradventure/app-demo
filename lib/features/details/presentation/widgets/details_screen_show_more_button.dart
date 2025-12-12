import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';

class ShowMoreButton extends StatelessWidget {
  final bool expanded;
  final VoidCallback onTap;

  const ShowMoreButton({
    super.key,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(
            bottom: BorderSide(color: AppColors.borderColor, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              expanded ? "Show Less" : "Show More",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Icon(
              expanded ? Icons.arrow_back : Icons.arrow_forward,
              color: AppColors.textBlack,
            ),
          ],
        ),
      ),
    );
  }
}
