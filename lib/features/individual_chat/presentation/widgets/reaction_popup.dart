import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:senior_circle/features/individual_chat/bloc/individual_chat_bloc.dart';
import 'package:senior_circle/features/individual_chat/model/individual_chat_message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/reaction_bar.dart';

OverlayEntry? _activeOverlay;

/// Call this on long-press of a message bubble
void showReactionPopup({
  required BuildContext context,
  required IndividualChatMessageModel message,
  required bool isMe,
}) {
  _activeOverlay?.remove();
  _activeOverlay = null;

  final overlay = Overlay.of(context);
  final renderBox = context.findRenderObject() as RenderBox;
  final position = renderBox.localToGlobal(Offset.zero);
  final size = renderBox.size;
  final screenWidth = MediaQuery.of(context).size.width;

  const menuWidth = 220.0;

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        entry.remove();
        _activeOverlay = null;
      },
      child: Stack(
        children: [
          /// ---------------- REACTION BAR ----------------
          Positioned(
            top: position.dy - 56,
            left: isMe ? position.dx + size.width - 300 : position.dx,
            child: Material(
              color: Colors.transparent,
              child: ReactionBar(
                onAddTap: () {
                  entry.remove();
                  _activeOverlay = null;

                  _openEmojiPicker(context: context, messageId: message.id);
                },

                /// QUICK REACTIONS
                onReactionTap: (emoji) {
                  context.read<IndividualChatBloc>().add(
                    AddReactionToMessage(
                      messageId: message.id,
                      reaction: emoji,
                    ),
                  );

                  entry.remove();
                  _activeOverlay = null;
                },
              ),
            ),
          ),

          /// ---------------- MESSAGE MENU ----------------
          Positioned(
            top: position.dy + size.height + 8,
            left: isMe ? (screenWidth - menuWidth) - 16 : 16,
            width: menuWidth,
            child: Material(
              color: Colors.white,
              elevation: 8,
              borderRadius: BorderRadius.circular(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _menuItem(context, 'STAR', () {
                    context.read<IndividualChatBloc>().add(
                      StarMessage(message: message),
                    );

                    _showSnack(context, 'Message starred');
                  }),

                  const Divider(height: 1),

                  _menuItem(context, 'FORWARD', () {}),

                  const Divider(height: 1),

                  _menuItem(context, 'SHARE', () {}),

                  const Divider(height: 1),

                  /// ✅ DELETE FOR ME
                  _menuItem(context, 'DELETE FOR ME', () {
                    context.read<IndividualChatBloc>().add(
                      DeleteMessageForMe(message.id),
                    );

                    _showSnack(context, 'Message deleted for you');
                  }),

                  if (isMe) ...[
                    const Divider(height: 1),

                    /// DELETE FOR EVERYONE
                    _menuItem(context, 'DELETE FOR EVERYONE', () {
                      context.read<IndividualChatBloc>().add(
                        DeleteMessageForEveryone(message: message),
                      );

                      _showSnack(context, 'Message deleted for everyone');
                    }),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  overlay.insert(entry);
  _activeOverlay = entry;
}

/// ---------------- MENU ITEM ----------------
Widget _menuItem(BuildContext context, String text, VoidCallback onTap) {
  return InkWell(
    onTap: () {
      _activeOverlay?.remove();
      _activeOverlay = null;
      onTap();
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: const TextStyle(fontSize: 14)),
      ),
    ),
  );
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
          onEmojiSelected: (_, emoji) {
            context.read<IndividualChatBloc>().add(
              AddReactionToMessage(messageId: messageId, reaction: emoji.emoji),
            );

            Navigator.pop(context);
          },
          config: const Config(
            height: 300,
            emojiViewConfig: EmojiViewConfig(emojiSizeMax: 25, columns: 8),
            bottomActionBarConfig: BottomActionBarConfig(enabled: false),
          ),
        ),
      );
    },
  );
}

/// ---------------- SNACKBAR HELPER ----------------
void _showSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
    );
}
