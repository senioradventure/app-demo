import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/individual_chat/model/individual_user_profile_model.dart';
import 'package:senior_circle/features/individual_chat/repositories/individual_chat_remote_repository.dart';

void showUserProfileBottomSheet(BuildContext context, String userId) {
  final repo = IndividualChatRemoteRepository();

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: Colors.white,
    builder: (_) {
      return FutureBuilder<UserProfile>(
        future: repo.getUserProfile(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: 250,
              child: const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          if (!snapshot.hasData) {
            return SizedBox(
              height: 250,
              child: const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('Failed to load profile')),
              ),
            );
          }

          final profile = snapshot.data!;

          return SizedBox(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  // Profile Image
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          profile.avatarUrl ??
                              'https://ui-avatars.com/api/?name=${profile.name}',
                        ),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Name
                  Text(
                    profile.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Location
                  if (profile.locationName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'From ${profile.locationName}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Remove Friend
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      // handle remove friend
                    },
                    child: Container(
                      color: AppColors.lightGray,
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
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
