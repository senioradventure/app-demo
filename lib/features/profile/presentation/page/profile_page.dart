import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/common/widgets/common_app_bar.dart';
import 'package:senior_circle/core/constants/friends_list.dart';
import 'package:senior_circle/core/enum/profile_visibility.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/utils/phone_number_masker.dart';
import 'package:senior_circle/features/profile/bloc/profile_bloc.dart';
import 'package:senior_circle/features/profile/bloc/profile_event.dart';
import 'package:senior_circle/features/profile/bloc/profile_state.dart';
import 'package:senior_circle/features/profile/models/profile_model.dart';
import 'package:senior_circle/features/profile/presentation/widgets/profile_details_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyText = theme.textTheme.bodyLarge!.copyWith(
      color: AppColors.textDarkGray,
    );
    final sectionText = theme.textTheme.headlineMedium!.copyWith(
      letterSpacing: -0.04,
    );

    return Scaffold(
      appBar: const CommonAppBar(title: 'Profile'),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial || state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProfileBloc>().add(LoadProfile());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ProfileLoaded) {
            final profile = state.profile;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ProfileDetailsWidget(
                      imageUrl: state.profile.avatarUrl ?? '',
                      name: state.profile.fullName ?? '',
                      phone:maskPhoneNumber(state.profile.username?? ''),
                      friends: friends.length,
                    ),
                  ),

                  sectionTitle('Privacy Settings', sectionText),
                  visibilityTile(context, bodyText, profile),

                  const SizedBox(height: 6),

                  sectionTitle('Support', sectionText),
                  settingsCard(
                    child: Column(
                      children: [
                        supportTile(
                          title: 'Help & Support',
                          onTap: () {},
                          textStyle: bodyText,
                        ),
                        Divider(color: AppColors.darkGray, height: 1),
                        supportTile(
                          title: 'Terms & Conditions',
                          onTap: () {},
                          textStyle: bodyText,
                        ),
                        Divider(color: AppColors.darkGray, height: 1),
                        supportTile(
                          title: 'Logout',
                          onTap: () {},
                          textStyle: bodyText,
                          textColor: AppColors.red,
                          iconColor: AppColors.red,
                        ),
                      ],
                    ),
                  ),

                  appVersion(context),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget sectionTitle(String title, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(title, style: style),
    );
  }

  Widget visibilityTile(
    BuildContext context,
    TextStyle textStyle,
    Profile profile,
  ) {
    return settingsCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Friend Request Privacy', style: textStyle),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<ProfileVisibility>(
                  value: profile.settings!.visibility,
                  icon: Icon(Icons.keyboard_arrow_down, size: 20),
                  
                  items: ProfileVisibility.values.map((v) {
                    return DropdownMenuItem(
                      value: v,

                      child: Text(
                        v.label,
                        style: textStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    context.read<ProfileBloc>().add(
                      UpdateProfileVisibility(value),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget settingsCard({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderColor),
      ),
      child: child,
    );
  }

  Widget supportTile({
    required String title,
    required VoidCallback onTap,
    required TextStyle textStyle,
    Color textColor = AppColors.textDarkGray,
    Color iconColor = AppColors.iconColor,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 68,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: textStyle.copyWith(color: textColor)),
                Icon(Icons.chevron_right, color: iconColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget appVersion(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'Version 1.0',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
