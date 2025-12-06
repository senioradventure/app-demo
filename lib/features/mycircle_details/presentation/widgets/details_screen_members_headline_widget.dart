import 'package:flutter/material.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';

class MemberHeadline extends StatelessWidget {
  final VoidCallback? onAddMember;
  const MemberHeadline({super.key, this.onAddMember});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Members", style: Theme.of(context).textTheme.headlineMedium),
        GestureDetector(
          onTap: onAddMember,
          child: CircleAvatar(
            radius: 11,
            backgroundColor: AppColors.buttonBlue,
            child: const Icon(Icons.add, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
