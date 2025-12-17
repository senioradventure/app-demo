import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';

class StarredMessageWidget extends StatelessWidget {
  const StarredMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle tap event
      },
      child: Container(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 12,
          bottom: 12,
        ),
        child: Row(
          children: [
            SvgPicture.asset('assets/icons/starred_messages.svg'),
            SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 16, bottom: 16),
              child: Text(
                'Starred Messages',
                style: AppTextTheme.lightTextTheme.titleMedium,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.iconColor),
          ],
        ),
      ),
    );
  }
}
