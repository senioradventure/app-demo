import 'package:flutter/material.dart';

class UserCountBadge extends StatelessWidget {
  final int count;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;

  const UserCountBadge({
    super.key,
    required this.count,
    this.backgroundColor = const Color(0xFF4A90E2),
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icons/user.png',
            width: 14,
            height: 14,
            color: iconColor,
            filterQuality: FilterQuality.high,
          ),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
