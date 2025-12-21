import 'package:equatable/equatable.dart';
import '../models/circle_chat_model.dart';

abstract class CircleChatState extends Equatable {
  const CircleChatState();

  @override
  List<Object?> get props => [];
}

class ChatLoading extends CircleChatState {}

class ChatLoaded extends CircleChatState {
  final List<CircleChat> chats;

  const ChatLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class ChatError extends CircleChatState {
  final String message;

  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
