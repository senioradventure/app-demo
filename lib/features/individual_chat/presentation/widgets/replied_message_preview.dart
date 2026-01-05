import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/individual_chat/bloc/individual_chat_bloc.dart';
import 'package:senior_circle/features/individual_chat/model/individual_chat_message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RepliedMessagePreview extends StatelessWidget {
  final IndividualChatMessageModel message;
  final bool isMe;

  const RepliedMessagePreview({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndividualChatBloc, IndividualChatState>(
      builder: (context, state) {
        if (state is! IndividualChatLoaded) {
          return const SizedBox.shrink();
        }

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

        final isFromMe =
            repliedMessage.senderId ==
            Supabase.instance.client.auth.currentUser?.id;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(6),
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
            children: [
              Text(
                isFromMe ? 'You' : 'Other User',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isMe ? Colors.white : Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                repliedMessage.content.isEmpty
                    ? '📷 Photo'
                    : repliedMessage.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: isMe ? Colors.white.withOpacity(0.8) : Colors.black54,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
