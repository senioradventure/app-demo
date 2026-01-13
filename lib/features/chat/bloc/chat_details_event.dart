import 'package:equatable/equatable.dart';
import '../models/chat_details_models.dart';

abstract class ChatDetailsEvent extends Equatable {
  const ChatDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadChatDetails extends ChatDetailsEvent {
  final String chatId;
  final ChatType type;

  const LoadChatDetails({required this.chatId, required this.type});

  @override
  List<Object?> get props => [chatId, type];
}
