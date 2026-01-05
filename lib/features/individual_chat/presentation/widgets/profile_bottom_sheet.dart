import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';

void showUserProfileBottomSheet(
  BuildContext context,
  String userName,
  String profileUrl,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: Colors.white,
    builder: (_) {
      return Padding(
        padding: EdgeInsetsGeometry.only(top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(profileUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 12),

            // Name
            Text(
              userName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 6),

            // Location Chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'From Malappuram',
                style: TextStyle(fontSize: 12),
              ),
            ),

            const SizedBox(height: 20),
            // Remove Friend
            InkWell(
              onTap: () {
                Navigator.pop(context);
                // 🔥 handle remove friend
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_remove, color: Colors.red),
                    SizedBox(width: 8),
                    Text(
                      'REMOVE FRIEND',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      );
    },
  );
}
