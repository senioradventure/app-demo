import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/profile/bloc/profile_bloc.dart';
import 'package:senior_circle/features/profile/presentation/page/edit_profile_page.dart';
import 'package:senior_circle/features/view_friends/bloc/view_friends_bloc.dart';
import 'package:senior_circle/features/view_friends/bloc/view_friends_event.dart';
import 'package:senior_circle/features/view_friends/presentation/page/view_friends_page.dart';

class FriendsCard extends StatelessWidget {
  const FriendsCard({super.key, required this.friends});

  final int? friends;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${friends ?? 0} Friends',
                  style: theme.textTheme.displaySmall!.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.04,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (_) => ViewFriendsBloc()..add(LoadFriends()),
                          child: const ViewFriendsPage(),
                        ),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  label: Text(
                    'See all',
                    style: theme.textTheme.displaySmall!.copyWith(
                      color: AppColors.buttonBlue,
                    ),
                  ),
                  icon: SvgPicture.asset('assets/icons/arrow_right.svg'),
                  iconAlignment: IconAlignment.end,
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(4),
            child: InkWell(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<ProfileBloc>(),
                      child: const EditProfilePage(),
                    ),
                  ),
                );
              },

              borderRadius: BorderRadius.circular(4),
              splashColor: AppColors.chipBlue,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: AppColors.borderColor)),
                ),
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/icons/edit_icon.svg'),
                    const SizedBox(width: 8),
                    Text(
                      'EDIT PROFILE',
                      style: theme.textTheme.displaySmall!.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.04,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
