import 'package:flutter/material.dart';
import 'package:senior_circle/features/individual_chat/model/individual_chat_message_model.dart';
import 'package:senior_circle/features/individual_chat/presentation/widgets/message_bubble_individual.dart';
import 'package:senior_circle/features/individual_chat/presentation/widgets/reaction_popup.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IndividualMessageCard extends StatelessWidget {
  final IndividualChatMessageModel message;

  const IndividualMessageCard({super.key, required this.message});

  bool get isMe =>
      message.senderId == Supabase.instance.client.auth.currentUser?.id;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onLongPress: () =>
              showReactionPopup(context: context, message: message, isMe: isMe),

          child: MessageBubbleIndividual(message: message, isMe: isMe),
        ),
      ),
    );
  }
}
