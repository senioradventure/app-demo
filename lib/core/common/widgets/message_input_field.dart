import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/common/widgets/image_preview.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';

class MessageInputField extends StatefulWidget {
  final void Function(String? text, String? imagePath) onSend;
  final String? initialText;
  final String? initialMediaUrl;

  const MessageInputField({
    super.key,
    required this.onSend,
    this.initialText,
    this.initialMediaUrl,
  });

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final TextEditingController _controller = TextEditingController();
  XFile? _selectedImage;
  String? _prefilledImageUrl;

  bool get _canSend =>
      _controller.text.trim().isNotEmpty || 
      _selectedImage != null || 
      _prefilledImageUrl != null;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialText ?? '';
    _prefilledImageUrl = widget.initialMediaUrl;
  }

  @override
  void didUpdateWidget(covariant MessageInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialText != oldWidget.initialText && widget.initialText != null) {
      _controller.text = widget.initialText!;
    }
    if (widget.initialMediaUrl != oldWidget.initialMediaUrl && widget.initialMediaUrl != null) {
      _prefilledImageUrl = widget.initialMediaUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
      color: AppColors.lightGray,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedImage != null || _prefilledImageUrl != null)
            _buildImagePreview(),

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
                      _prefilledImageUrl = null; // Clear prefilled if new picked
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                    left: 4,
                  ), 
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
                    onChanged: (_) {
                      setState(() {});
                    },
                    minLines: 1,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      hintStyle: AppTextTheme.lightTextTheme.labelMedium,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(70)),
                        borderSide: BorderSide(color: AppColors.darkGray),
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
                          _selectedImage?.path ?? _prefilledImageUrl,
                        );
                        _controller.clear();
                        setState(() {
                          _selectedImage = null;
                          _prefilledImageUrl = null;
                        });
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

  Widget _buildImagePreview() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Stack(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: _selectedImage != null
                   ? FileImage(File(_selectedImage!.path))
                   : NetworkImage(_prefilledImageUrl!) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedImage = null;
                  _prefilledImageUrl = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
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
