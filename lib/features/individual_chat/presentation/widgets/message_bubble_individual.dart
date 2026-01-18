import 'package:flutter/material.dart';
import 'package:senior_circle/features/individual_chat/model/individual_chat_message_model.dart';
import 'package:senior_circle/features/individual_chat/model/individual_message_reaction_model.dart';
import 'package:senior_circle/features/individual_chat/presentation/widgets/message_file_bubble.dart';
import 'package:senior_circle/features/individual_chat/presentation/widgets/message_image.dart';
import 'package:senior_circle/features/individual_chat/presentation/widgets/message_time.dart';
import 'package:senior_circle/features/individual_chat/presentation/widgets/message_voice_bubble.dart';
import 'package:senior_circle/features/individual_chat/presentation/widgets/replied_message_preview.dart';

class MessageBubbleIndividual extends StatelessWidget {
  final IndividualChatMessageModel message;
  final bool isMe;

  const MessageBubbleIndividual({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final groupedReactions = groupReactions(message.reactions);

    return Column(
      crossAxisAlignment: isMe
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
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
                  /// ---------------- REPLY PREVIEW ----------------
                  if (message.replyToMessageId != null)
                    RepliedMessagePreview(message: message, isMe: isMe),

                  /// ---------------- IMAGE ----------------
                  if (message.mediaType == 'image' &&
                      (message.localMediaPath != null ||
                          message.mediaUrl != null))
                    MessageImage(
                      localPath: message.localMediaPath,
                      url: message.mediaUrl,
                    ),

                  /// ---------------- FILE ----------------
                  if (message.mediaType == 'file' &&
                      (message.localMediaPath != null ||
                          message.mediaUrl != null))
                    MessageFileBubble(
                      localPath: message.localMediaPath,
                      fileUrl: message.mediaUrl,
                      isMe: isMe,
                    ),

                  /// ---------------- VOICE ----------------
                  if (message.mediaType == 'audio' &&
                      (message.localMediaPath != null ||
                          message.mediaUrl != null))
                    MessageVoiceBubble(
                      localPath: message.localMediaPath,
                      audioUrl: message.mediaUrl,
                      isMe: isMe,
                    ),

                  /// ---------------- TEXT ----------------
                  if (message.content.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        message.content,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ),

                  const SizedBox(height: 4),
                  MessageTime(dateTime: message.createdAt, isMe: isMe),
                ],
              ),
            ),
          ),
        ),

        /// ---------------- REACTIONS ----------------
        if (message.reactions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Wrap(
              spacing: 4,
              children: message.reactions
                  .map(
                    (r) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        r.reaction,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}

/// ================= REACTION GROUPING =================

Map<String, int> groupReactions(List<MessageReaction> reactions) {
  final Map<String, int> map = {};
  for (final r in reactions) {
    map[r.reaction] = (map[r.reaction] ?? 0) + 1;
  }
  return map;
}
