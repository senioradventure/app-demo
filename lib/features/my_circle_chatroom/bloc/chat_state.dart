import 'package:equatable/equatable.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';

class ChatState extends Equatable {
  final List<GroupMessage> groupMessages;
  final bool isLoading;
  final String? error;
  final String? prefilledInputText;
  final ForwardMedia? prefilledMedia;
  final bool isSending;

  const ChatState({
    this.groupMessages = const [],
    this.isLoading = false,
    this.error,
    this.prefilledInputText,
    this.prefilledMedia,
    this.isSending = false,
  });

  ChatState copyWith({
    List<GroupMessage>? groupMessages,
    bool? isLoading,
    String? error,
     String? prefilledInputText,
     ForwardMedia? prefilledMedia,
     bool? isSending,

  }) {
    return ChatState(
      groupMessages: groupMessages ?? this.groupMessages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      prefilledInputText: prefilledInputText ?? this.prefilledInputText,
      prefilledMedia: prefilledMedia ?? this.prefilledMedia,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [groupMessages, isLoading, error, prefilledInputText, prefilledMedia, isSending];
}

class ForwardMedia {
  final String url;
  final String type;

  ForwardMedia({required this.url, required this.type});
}