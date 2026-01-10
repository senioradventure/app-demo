import 'package:equatable/equatable.dart';

abstract class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();

  @override
  List<Object?> get props => [];
}

class ChatRoomStarted extends ChatRoomEvent {
  final String roomId;

  const ChatRoomStarted(this.roomId);

  @override
  List<Object?> get props => [roomId];
}
class ChatMessageSendRequested extends ChatRoomEvent {
  final String text;

  const ChatMessageSendRequested(this.text);

  @override
  List<Object?> get props => [text];
}
class ChatTypingChanged extends ChatRoomEvent {
  final bool isTyping;
  const ChatTypingChanged(this.isTyping);

  @override
  List<Object?> get props => [isTyping];
}
class ChatImageSelected extends ChatRoomEvent {
  final String imagePath;
  const ChatImageSelected(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class ChatImageCleared extends ChatRoomEvent {
  const ChatImageCleared();
}


