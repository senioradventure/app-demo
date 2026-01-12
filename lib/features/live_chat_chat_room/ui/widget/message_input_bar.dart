import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_bloc.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_event.dart';

class ChatInputBar extends StatelessWidget {
  final ImagePicker picker;
  final TextEditingController messageController;
  final VoidCallback onSend;
  final bool showSend;
  const ChatInputBar({
    super.key,
    required this.picker,
    required this.messageController,
    required this.onSend,
    required this.showSend,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('Bloc hash: ${context.read<ChatRoomBloc>().hashCode}');

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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

                      context.read<ChatRoomBloc>().add(
                        ChatImageSelected(picked.path),
                      );
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
                        onChanged: (value) {
                          context.read<ChatRoomBloc>().add(
                            ChatTypingChanged(value.trim().isNotEmpty),
                          );
                        },
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
                    onTap: showSend ? onSend : null,
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: Image.asset(
                        showSend
                            ? 'assets/icons/fab2.png'
                            : 'assets/icons/fab.png',
                      ),
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
