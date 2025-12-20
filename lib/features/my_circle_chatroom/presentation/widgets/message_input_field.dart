import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';

class MessageInputField extends StatefulWidget {
  final Function(String) onSend;
  const MessageInputField({super.key, required this.onSend});

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _controller = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _isTyping) {
        setState(() => _isTyping = hasText);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: AppColors.lightGray,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end, // Keeps buttons at bottom
        children: [
          IconButton(
            onPressed: () {
              ImagePicker().pickImage(source: ImageSource.gallery);
            },
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
                controller: _controller,
                minLines: 1,
                maxLines: null, 
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: "Type a message",
                  hintStyle: AppTextTheme.lightTextTheme.labelMedium,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
         InkWell(
              onTap: () {
                if (_isTyping) {
                  widget.onSend(_controller.text.trim());
                  _controller.clear();
                }
              },
              child: _isTyping
                  ? SvgPicture.asset('assets/icons/send_icon.svg')
                  : SvgPicture.asset('assets/icons/mic_button.svg'),
            ),
          
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}