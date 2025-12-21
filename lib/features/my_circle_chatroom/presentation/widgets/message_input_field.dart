import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/common/image_preview.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';

class MessageInputField extends StatefulWidget {
  final void Function(String? text, String? imagePath) onSend;

  const MessageInputField({super.key, required this.onSend});

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _controller = TextEditingController();
  XFile? _selectedImage;

  bool get _canSend =>
      _controller.text.trim().isNotEmpty || _selectedImage != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
      color: AppColors.lightGray,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedImage != null)
            ImagePreview(
              selectedImage: _selectedImage!,
              onRemove: () {
                setState(() {
                  _selectedImage = null;
                });
              },
            ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() {
                      _selectedImage = image;
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                    left: 4,
                  ), // 👈 SAME spacing
                  child: SvgPicture.asset(
                    'assets/icons/add_media_chat_icon.svg',
                  ),
                ),
              ),

              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  height: 46,

                  child: TextField(
                    controller: _controller,

                    minLines: 1,
                    maxLines: 1,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      hintStyle: AppTextTheme.lightTextTheme.labelMedium,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(70),
                        borderSide: BorderSide(color: AppColors.darkGray),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(70),
                        borderSide: BorderSide(color: AppColors.buttonBlue),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: _canSend
                    ? () {
                        widget.onSend(
                          _controller.text.trim().isEmpty
                              ? null
                              : _controller.text.trim(),
                          _selectedImage?.path,
                        );
                        _controller.clear();
                        setState(() => _selectedImage = null);
                      }
                    : null,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SvgPicture.asset(
                    _canSend
                        ? 'assets/icons/send_icon.svg'
                        : 'assets/icons/mic_button.svg',
                  ),
                ),
              ),
            ],
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
