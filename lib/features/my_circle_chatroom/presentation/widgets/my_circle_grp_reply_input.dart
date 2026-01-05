import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_bloc.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_event.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';

class BuildReplyInputField extends StatelessWidget {
  const BuildReplyInputField({
    super.key,
    required TextEditingController replyController,
    required this.grpmessage,
  }) : _replyController = replyController;

  final TextEditingController _replyController;
  final GroupMessage grpmessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextField(
        controller: _replyController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: "Write a reply...",
          hintStyle: AppTextTheme.lightTextTheme.labelMedium,
          suffixIcon: IconButton(
            icon: const Icon(Icons.send, color: AppColors.buttonBlue),
            onPressed: () {
              if (_replyController.text.trim().isEmpty) return;

              context.read<ChatBloc>().add(
                SendGroupMessage(
                  text: _replyController.text.trim(),
                  replyToMessageId: grpmessage.id,
                ),
              );

              _replyController.clear();

              context.read<ChatBloc>().add(
                ToggleReplyInput(messageId: grpmessage.id),
              );
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColors.borderColor),
            // The original code had borderSide here but simpler to just set it 
            // the decorator will handle focus etc if we use outline input border
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}
