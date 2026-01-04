import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/widget/image_preview.dart';

class ChatInputBar extends StatelessWidget {
  final ImagePicker picker;
  final ValueNotifier<String?> pendingImage;
  final ValueNotifier<bool> isTyping;
  final ValueNotifier<int> fabRebuild;
  final TextEditingController messageController;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.picker,
    required this.pendingImage,
    required this.isTyping,
    required this.fabRebuild,
    required this.messageController,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SelectedImagePreview(imageNotifier: pendingImage),

            Container(
              height: 75,
              color: const Color(0xFFF9F9F7),
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 12,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Image.asset('assets/icons/Vector.png'),
                    onPressed: () async {
                      final XFile? picked = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (picked == null) return;
                      pendingImage.value = picked.path;
                    },
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFDDDDDD)),
                      ),
                      child: TextField(
                        controller: messageController,
                        onChanged: (v) => isTyping.value = v.trim().isNotEmpty,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Type a message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onSend,
                    child: ValueListenableBuilder<int>(
                      valueListenable: fabRebuild,
                      builder: (context, _, __) {
                        final showFab2 =
                            isTyping.value || pendingImage.value != null;
                        return SizedBox(
                          width: 50,
                          height: 50,
                          child: Image.asset(
                            showFab2
                                ? 'assets/icons/fab2.png'
                                : 'assets/icons/fab.png',
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
