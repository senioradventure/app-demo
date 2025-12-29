import 'package:flutter/material.dart';
import 'package:senior_circle/core/common/widgets/common_app_bar.dart';
import 'package:senior_circle/core/constants/friends_list.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/profile/presentation/widgets/profile_details_widget.dart';
import 'package:senior_circle/features/profile/presentation/widgets/visibility_drop_down_widget.dart';

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: ProfileDetailsWidget(
                name: 'Name',
                phone: '+91 23xxxxxxxx',
                friends: friends.length,
              ),
            ),

            sectionTitle('Privacy Settings', sectionText),
            visibilityTile(context, bodyText),

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
      ),
    );
  }

  Widget sectionTitle(String title, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(title, style: style),
    );
  }

  Widget visibilityTile(BuildContext context, TextStyle textStyle) {
    return settingsCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Visibility', style: textStyle),
             VisibilityDropdown(),
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
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Text(
          'Version 1.0',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
