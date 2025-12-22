import 'package:equatable/equatable.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/message_model.dart';


class ChatState extends Equatable {
  final List<Message> messages;
  final List<GroupMessage> groupMessages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.groupMessages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<Message>? messages,
    List<GroupMessage>? groupMessages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      groupMessages: groupMessages ?? this.groupMessages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [messages, groupMessages, isLoading, error];
}
