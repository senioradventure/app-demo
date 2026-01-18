import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/notification/bloc/notification_bloc.dart';
import 'package:senior_circle/features/notification/bloc/notification_event.dart';
import 'package:senior_circle/features/notification/repository/notification_repository.dart';
import 'package:senior_circle/features/notification/presentation/page/notification_page.dart';
import 'package:senior_circle/features/profile/presentation/page/profile_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PageHeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? profileImage;

  const PageHeaderAppBar({super.key, required this.title, this.profileImage});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    void onProfileTap() {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const ProfilePage()));
    }

    void onNotificationTap() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return BlocProvider(
              create: (_) => NotificationBloc(
                NotificationRepository(Supabase.instance.client),
              )..add(LoadNotifications()),
              child: const NotificationPage(),
            );
          },
        ),
      );
    }

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                letterSpacing: -0.04,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            _notificationIcon(onNotificationTap),
            const SizedBox(width: 8),
            _profileAvatar(onProfileTap),
          ],
        ),
      ),
    );
  }

  Widget _notificationIcon(GestureTapCallback? onNotificationTap) {
    return InkWell(
      onTap: onNotificationTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: SvgPicture.asset('assets/icons/notification_bell.svg'),
      ),
    );
  }

  Widget _profileAvatar(GestureTapCallback? onProfileTap) {
    const double size = 34;
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
              ? Image.network(
                  profileImage!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                )
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
