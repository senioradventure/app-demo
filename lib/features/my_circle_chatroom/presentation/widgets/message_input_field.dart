import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';

class MessageInputField extends StatelessWidget {
  const MessageInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: AppColors.lightGray,
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add, color: AppColors.buttonBlue, size: 28),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: "Type a message",
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {},
            child: SvgPicture.asset('assets/icons/mic_button.svg'),
          ),
        ],
      ),
    );
  }
}
