part of 'individual_chat_bloc.dart';

sealed class IndividualChatEvent extends Equatable {
  const IndividualChatEvent();
  @override
  List<Object?> get props => [];
}

class LoadConversationMessages extends IndividualChatEvent {
  final String conversationId;
  const LoadConversationMessages(this.conversationId);
}

class PickReplyMessage extends IndividualChatEvent {
  final IndividualChatMessageModel message;
  const PickReplyMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class ClearReplyMessage extends IndividualChatEvent {}

class PickMessageImage extends IndividualChatEvent {
  final String imagePath;
  const PickMessageImage(this.imagePath);
}

class RemovePickedImage extends IndividualChatEvent {}

class SendConversationMessage extends IndividualChatEvent {
  final String text;
  const SendConversationMessage({required this.text});

  @override
  List<Object?> get props => [text];
}

class AddReactionToMessage extends IndividualChatEvent {
  final String messageId;
  final String reaction;

  const AddReactionToMessage({required this.messageId, required this.reaction});

  @override
  List<Object?> get props => [messageId, reaction];
}
