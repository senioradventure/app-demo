import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';

ClipRRect individualProfileIcon(bool hasImage, String? imageUrl) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: hasImage
        ? Image.network(imageUrl!, width: 52, height: 52, fit: BoxFit.cover)
        : Container(
            width: 52,
            height: 52,
            color: AppColors.borderColor,
            child: const Icon(Icons.person),
          ),
  );
}
