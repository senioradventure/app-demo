import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/profile/presentation/widgets/friends_card_widget.dart';

class ProfileDetailsWidget extends StatelessWidget {
  final String? imageUrl;
  final int? friends;
  final String name;
  final String phone;

  const ProfileDetailsWidget({
    super.key,
    this.imageUrl,
    this.friends,
    required this.name,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
            backgroundColor: AppColors.borderColor,
            child: hasImage ? null : const Icon(Icons.person, size: 48),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: theme.textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          if (phone.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.chipBlue,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Text(phone, style: theme.textTheme.displaySmall),
            ),
          const SizedBox(height: 10),
          FriendsCard(friends: friends),
        ],
      ),
    );
  }
}


