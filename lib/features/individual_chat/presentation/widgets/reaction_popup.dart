import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:senior_circle/features/individual_chat/bloc/individual_chat_bloc.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/reaction_bar.dart';

OverlayEntry? _activeReactionOverlay;

/// Call this on long-press of message
void showReactionPopup(BuildContext context, String messageId) {
  // Remove any existing overlay
  _activeReactionOverlay?.remove();
  _activeReactionOverlay = null;

  final overlay = Overlay.of(context);
  final renderBox = context.findRenderObject() as RenderBox;
  final position = renderBox.localToGlobal(Offset.zero);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        entry.remove();
        _activeReactionOverlay = null;
      },
      child: Stack(
        children: [
          Positioned(
            top: position.dy - 60,
            left: position.dx,
            child: Material(
              color: Colors.transparent,
              child: ReactionBar(
                onAddTap: () {
                  entry.remove();
                  _activeReactionOverlay = null;

                  _openEmojiPicker(context: context, messageId: messageId);
                },

                /// QUICK REACTIONS
                onReactionTap: (emoji) {
                  context.read<IndividualChatBloc>().add(
                    AddReactionToMessage(messageId: messageId, reaction: emoji),
                  );

                  entry.remove();
                  _activeReactionOverlay = null;
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );

  overlay.insert(entry);
  _activeReactionOverlay = entry;
}

/// ---------------- EMOJI PICKER ----------------
void _openEmojiPicker({
  required BuildContext context,
  required String messageId,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return Container(
        height: 350,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            context.read<IndividualChatBloc>().add(
              AddReactionToMessage(messageId: messageId, reaction: emoji.emoji),
            );

            Navigator.pop(context);
          },
          config: const Config(
            height: 300,
            checkPlatformCompatibility: true,
            emojiViewConfig: EmojiViewConfig(emojiSizeMax: 25, columns: 8),
            categoryViewConfig: CategoryViewConfig(indicatorColor: Colors.blue),
            skinToneConfig: SkinToneConfig(enabled: true),
            bottomActionBarConfig: BottomActionBarConfig(enabled: false),
            searchViewConfig: SearchViewConfig(hintText: "Search emoji"),
          ),
        ),
      );
    },
  );
}
