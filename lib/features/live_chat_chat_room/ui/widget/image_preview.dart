import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_bloc.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_event.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/bloc/chat_room_state.dart';

class SelectedImagePreview extends StatelessWidget {
  const SelectedImagePreview({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ChatRoomBloc, ChatRoomState>(
      buildWhen: (prev, curr) =>
          prev.pendingImage != curr.pendingImage,
      builder: (context, state) {
        final path = state.pendingImage;

        if (path == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(path),
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: GestureDetector(
                  onTap: () {
                    context.read<ChatRoomBloc>().add(
                      const ChatImageCleared(),
                    );
                  },
                  child: const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.black54,
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
