import 'package:flutter/material.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';

class MembersListView extends StatelessWidget {
  final List<Map<String, dynamic>> members;

  const MembersListView({super.key, required this.members});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];

        return Column(
          children: [
            Container(
              height: 59,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: AppColors.white,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(member["url"]),
                  ),
                  const SizedBox(width: 12),

                  /// Name
                  Expanded(
                    child: Text(
                      member["name"],
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),

                  /// Admin badge
                  if (member["admin"] == 1)
                    Container(
                      width: 44,
                      height: 22,
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        color: AppColors.adminColor,
                      ),
                      child: Text(
                        "Admin",
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textBlack,
                            ),
                      ),
                    ),
                ],
              ),
            ),

            /// Divider for each row
            Divider(color: AppColors.borderColor, height: 1),
          ],
        );
      },
    );
  }
}
