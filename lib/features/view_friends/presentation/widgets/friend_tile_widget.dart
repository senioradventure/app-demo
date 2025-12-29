import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/view_friends/models/friends_model.dart';

class FriendTile extends StatelessWidget {
  final Friend friend;

  const FriendTile({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(friend.imageUrl),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.name,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDarkGray,
                      ),
                    ),
                    if (friend.isOnline) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.circle, size: 14, color: AppColors.green),
                          SizedBox(width: 6),
                          Text(
                            'Online',
                            style: Theme.of(context).textTheme.labelSmall!
                                .copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.green,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              IconButton(
                icon: SvgPicture.asset('assets/icons/message_circle.svg'),
                onPressed: () {},
              ),

              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
