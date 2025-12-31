import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/live_chat_home/presentation/widget/common_page_header.dart';
import 'package:senior_circle/features/profile/bloc/profile_bloc.dart';
import 'package:senior_circle/features/profile/bloc/profile_state.dart';

class ProfileAwareAppBar extends StatelessWidget
    implements PreferredSizeWidget {

  final String title;

  const ProfileAwareAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
  buildWhen: (prev, curr) => curr is ProfileLoaded,
  builder: (context, state) {
    if (state is ProfileLoaded) {
      debugPrint('APPBAR AVATAR URL: ${state.profile.avatarUrl}');
    }
    final avatarUrl = state is ProfileLoaded
        ? state.profile.avatarUrl
        : null;
        return PageHeaderAppBar(
          title: title,
          profileImage:
              (avatarUrl != null && avatarUrl.isNotEmpty) ? avatarUrl : null,
        );
      },
    );
  }
}
