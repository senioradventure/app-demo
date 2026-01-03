import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';

class MessageInputBar extends StatelessWidget {
  final ImagePicker picker;
  final ValueNotifier<String?> pendingImage;
  final ValueNotifier<bool> isTyping;
  final TextEditingController controller;

  const MessageInputBar({
    super.key,
    required this.picker,
    required this.pendingImage,
    required this.isTyping,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
            icon: Image.asset('assets/icons/Vector.png'),
            onPressed: () async {
              final img = await picker.pickImage(source: ImageSource.gallery);
              if (img != null) pendingImage.value = img.path;
            },
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (v) => isTyping.value = v.trim().isNotEmpty,
              decoration: const InputDecoration(
                hintText: "Type a message",
                border: InputBorder.none,
              ),
            ),
          ),
         AnimatedBuilder(
  animation: Listenable.merge([isTyping, pendingImage]),
  builder: (context, _) {
    final bool showSend =
        isTyping.value || pendingImage.value != null;

    return GestureDetector(
      onTap: () {
        if (!showSend) {

          return;
        }

        chatMessages.value = [
          ...chatMessages.value,
          ChatMessage(
            isSender: true,
            text: controller.text,
            time: TimeOfDay.now().format(context),
            imageFile: pendingImage.value,
          ),
        ];

        controller.clear();
        pendingImage.value = null;
        isTyping.value = false;
      },
      child: Image.asset(
        showSend
            ? 'assets/icons/fab2.png' 
            : 'assets/icons/fab.png', 
        width: 44,
        height: 44,
      ),
    );
  },
),

        ],
      ),
    );
  }
}
