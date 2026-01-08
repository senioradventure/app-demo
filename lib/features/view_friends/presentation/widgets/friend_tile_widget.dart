import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_circle/core/common/widgets/individual_profile_icon.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/individual_chat/bloc/individual_chat_bloc.dart';
import 'package:senior_circle/features/individual_chat/presentation/my_circle_individual_chat_page.dart';
import 'package:senior_circle/features/individual_chat/repositories/individual_chat_repository.dart';
import 'package:senior_circle/features/view_friends/models/friends_model.dart';
import 'package:senior_circle/features/view_friends/repository/view_friends_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FriendTile extends StatelessWidget {
  final Friend friend;

  const FriendTile({super.key, required this.friend});

  @override
  Widget build(BuildContext context) {
    final bool hasImage =
        friend.profileImage != null && friend.profileImage!.isNotEmpty;

    final viewFriendsRepository = ViewFriendsRepository(
      Supabase.instance.client,
    );

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {}, // optional
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              individualProfileIcon(hasImage, friend.profileImage),

              const SizedBox(width: 12),

              /// 🔹 Name + online status
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

                    if (friend.isOnline == true) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 12,
                            color: AppColors.green,
                          ),
                          const SizedBox(width: 6),
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

              /// 🔹 Message button
              IconButton(
                icon: SizedBox(
                  width: 24,
                  height: 24,
                  child: SvgPicture.asset('assets/icons/message_circle.svg'),
                ),
                onPressed: () async {
                  final chat = await viewFriendsRepository
                      .getOrCreateIndividualChatWithFriend(friend.id);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider(
                        create: (_) =>
                            IndividualChatBloc(IndividualChatRepository())
                              ..add(LoadConversationMessages(chat.id)),
                        child: MyCircleIndividualChatPage(chat: chat),
                      ),
                    ),
                  );
                },
              ),

              IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
