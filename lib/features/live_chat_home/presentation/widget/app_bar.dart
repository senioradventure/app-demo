import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final double topPadding;
  final double leftPadding;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final String? profileImage;

  const PageHeader({
    super.key,
    required this.title,
    this.topPadding = 12,
    this.leftPadding = 16,
    this.onNotificationTap,
    this.onProfileTap,
    this.profileImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: topPadding,
        left: leftPadding,
        right: leftPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),

          const Spacer(),
          _notificationIcon(),
          const SizedBox(width: 16),
          _profileAvatar(),
        ],
      ),
    );
  }

  Widget _notificationIcon() {
    return InkWell(
      onTap: onNotificationTap,
      borderRadius: BorderRadius.circular(24),
      child: SvgPicture.asset('assets/icons/notification_bell.svg'),
    );
  }

  Widget _profileAvatar() {
    const double size = 28;
    const double borderWidth = 2;

    return InkWell(
      onTap: onProfileTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.buttonBlue, width: borderWidth),
        ),
        child: ClipOval(
          child: profileImage != null
              ? Image.network(profileImage!, fit: BoxFit.cover)
              : Container(
                  color: Colors.grey.shade300,
                  child: const Icon(
                    Icons.person,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
