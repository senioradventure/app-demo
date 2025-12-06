import 'package:flutter/material.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';
import 'package:senior_circle/theme/texttheme/text_theme.dart';

class MyCircleChatroomAppBar extends StatelessWidget {
  const MyCircleChatroomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          height: MediaQuery.of(context).size.height * 0.1,
          color: AppColors.backgroundColor,
          child: Padding(
            padding: const EdgeInsets.only(top: 24, left: 0, right: 12, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      AssetImage('assets/images/group_icon.png'),
                ),
                const SizedBox(width: 10),
                 Text(
                  'Chai Talks',
                  style: AppTextTheme.lightTextTheme.headlineMedium,),
                const Spacer(),
                
                IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Color(0xFF5C5C5C),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
  }
}