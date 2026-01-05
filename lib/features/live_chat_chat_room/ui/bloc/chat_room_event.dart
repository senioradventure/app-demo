part of 'chat_room_bloc.dart';

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
  final String? imagePath;

  const ChatMessageSendRequested({
    required this.text,
    this.imagePath,
  });

  @override
  List<Object?> get props => [text, imagePath];
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


class ChatMessagesUpdated extends ChatRoomEvent {
  final List<ChatMessage> messages;

  const ChatMessagesUpdated(this.messages);

  @override
  List<Object?> get props => [messages];
}


class ChatRoomErrorOccurred extends ChatRoomEvent {
  final String message;

  const ChatRoomErrorOccurred(this.message);

  @override
  List<Object?> get props => [message];
}
