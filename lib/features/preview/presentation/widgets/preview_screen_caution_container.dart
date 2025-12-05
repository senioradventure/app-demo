import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';

class CautionWidget extends StatelessWidget {
  const CautionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12, top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cautionColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/icons/caution_triangle.svg',
            width: 24,
            height: 24,
          ),
          const Text(
            "The room name, picture, and other details cannot be changed after the room is created",
          ),
        ],
      ),
    );
  }
}
