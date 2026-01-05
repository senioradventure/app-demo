import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/constants/reactions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:senior_circle/features/individual_chat/model/individual_chat_message_model.dart';
import 'package:senior_circle/features/individual_chat/bloc/individual_chat_bloc.dart';

class IndividualMessageCard2 extends StatelessWidget {
  final IndividualChatMessageModel message;

  const IndividualMessageCard2({super.key, required this.message});

  bool get isMe {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    return message.senderId == currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onLongPress: () => _showReactionPopup(context),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isMe ? Colors.blueAccent.shade200 : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(14),
                  topRight: const Radius.circular(14),
                  bottomLeft: isMe ? const Radius.circular(14) : Radius.zero,
                  bottomRight: isMe ? Radius.zero : const Radius.circular(14),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ---------------- REPLIED MESSAGE (TARGET) ----------------
                    if (message.replyToMessageId != null)
                      _buildRepliedMessage(context),

                    /// ---------------- IMAGE MESSAGE ----------------
                    if (message.mediaType == 'image' &&
                        message.mediaUrl != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _buildImage(message.mediaUrl!),
                      ),

                    /// ---------------- TEXT MESSAGE ----------------
                    if (message.content.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(
                          top: message.replyToMessageId != null ? 4 : 0,
                        ),
                        child: Text(
                          message.content,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                      ),

                    const SizedBox(height: 4),

                    /// ---------------- TIME ----------------
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        _formatTime(message.createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: isMe ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ---------------- REPLIED MESSAGE WIDGET (WhatsApp Style) ----------------
  Widget _buildRepliedMessage(BuildContext context) {
    return BlocBuilder<IndividualChatBloc, IndividualChatState>(
      builder: (context, state) {
        if (state is! IndividualChatLoaded) {
          return const SizedBox.shrink();
        }

        // Find the original message being replied to
        final repliedMessage = state.messages.firstWhere(
          (m) => m.id == message.replyToMessageId,
          orElse: () => IndividualChatMessageModel(
            id: '',
            senderId: '',
            content: 'Message deleted',
            mediaUrl: null,
            mediaType: 'text',
            createdAt: DateTime.now(),
            replyToMessageId: null,
          ),
        );

        final isRepliedMessageFromMe =
            repliedMessage.senderId ==
            Supabase.instance.client.auth.currentUser?.id;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isMe
                ? Colors.white.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border(
              left: BorderSide(
                color: isMe ? Colors.white : Colors.blueAccent,
                width: 3,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Sender name
              Text(
                isRepliedMessageFromMe ? 'You' : 'Other User',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isMe ? Colors.white : Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 3),

              /// Replied message content
              Row(
                children: [
                  /// Image thumbnail if media
                  if (repliedMessage.mediaType == 'image' &&
                      repliedMessage.mediaUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: _buildImage(repliedMessage.mediaUrl!),
                        ),
                      ),
                    ),

                  /// Text content
                  Expanded(
                    child: Text(
                      repliedMessage.content.isEmpty
                          ? (repliedMessage.mediaType == 'image'
                                ? '📷 Photo'
                                : 'Media')
                          : repliedMessage.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: isMe
                            ? Colors.white.withOpacity(0.8)
                            : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// ---------------- SHOW MESSAGE OPTIONS (FOR REPLY) ----------------
  void _showReactionPopup(BuildContext context) {
    OverlayEntry? _activeReactionOverlay;

    // Remove any existing popup first
    _activeReactionOverlay?.remove();
    _activeReactionOverlay = null;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          entry.remove();
          _activeReactionOverlay = null;
        },
        child: Stack(
          children: [
            Positioned(
              top: position.dy - 55,
              left: position.dx,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 6),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...defaultReactions.map(
                        (emoji) => GestureDetector(
                          onTap: () {
                            print('Reaction tapped: $emoji');
                            entry.remove();
                            _activeReactionOverlay = null;
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                      ),

                      /// ADD BUTTON
                      GestureDetector(
                        onTap: () {
                          print('Add reaction tapped');
                          entry.remove();
                          _activeReactionOverlay = null;
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Icon(Icons.add, size: 22),
                        ),
                      ),
                    ],
                  ),
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

  /// ---------------- IMAGE BUILDER ----------------
  Widget _buildImage(String url) {
    /// Local file (optimistic image)
    if (url.startsWith('/data/') || url.startsWith('file://')) {
      return Image.file(File(url), fit: BoxFit.cover);
    }

    /// Remote Supabase image
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const SizedBox(
          height: 150,
          child: Center(child: CircularProgressIndicator()),
        );
      },
      errorBuilder: (_, __, ___) {
        return const SizedBox(
          height: 150,
          child: Center(child: Icon(Icons.broken_image, size: 30)),
        );
      },
    );
  }

  /// ---------------- FORMAT TIME ----------------
  static String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}
