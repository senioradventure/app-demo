import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatEvent {}

class SendMessage extends ChatEvent {
  final String text;

  const SendMessage({required this.text});

  @override
  List<Object?> get props => [text];
}

class DeleteMessage extends ChatEvent {
  final String messageId;

  const DeleteMessage(this.messageId);

  @override
  List<Object?> get props => [messageId];
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
