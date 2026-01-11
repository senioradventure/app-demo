import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';

class AttachmentTile extends StatelessWidget {
  const AttachmentTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.buttonBlue),
      title: Text(title),
      onTap: onTap,
    );
  }
}
