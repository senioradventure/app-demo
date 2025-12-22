import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatEvent {}
class LoadGroupMessages extends ChatEvent {
  final String chatId;

  const LoadGroupMessages({required this.chatId});
}

class SendMessage extends ChatEvent {
  final String? text;
  final String? imagePath;

  const SendMessage({this.text,this.imagePath});

  @override
  List<Object?> get props => [text];
}

class SendImageMessage extends ChatEvent {
  final String imagePath;

  const SendImageMessage({required this.imagePath});
}

class DeleteMessage extends ChatEvent {
  final String messageId;

  const DeleteMessage(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class SendGroupMessage extends ChatEvent {
  final String? text;
  final String? imagePath;

  const SendGroupMessage({
    this.text,
    this.imagePath,
  });
}



class ToggleReaction extends ChatEvent {
  final String messageId;
  final String emoji;
  final String userId;

  const ToggleReaction({
    required this.messageId,
    required this.emoji,
    required this.userId,
  });

  @override
  List<Object?> get props => [messageId, emoji, userId];
}

class ToggleStar extends ChatEvent {
  final String messageId;
  final String userId;

  const ToggleStar({
    required this.messageId,
    required this.userId,
  });

  @override
  List<Object?> get props => [messageId, userId];
}
