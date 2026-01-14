import 'package:equatable/equatable.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';

class ChatState extends Equatable {
  final List<GroupMessage> groupMessages;
  final bool isLoading;
  final String? error;
  final String? prefilledInputText;
  final ForwardMedia? prefilledMedia;
  final bool isSending;
  final String? imagePath;
  final String? filePath;

  const ChatState({
    this.groupMessages = const [],
    this.isLoading = false,
    this.error,
    this.prefilledInputText,
    this.prefilledMedia,
    this.isSending = false,
    this.imagePath,
    this.filePath,
  });

  ChatState copyWith({
    List<GroupMessage>? groupMessages,
    bool? isLoading,
    Object? error = _undefined,
    Object? prefilledInputText = _undefined,
    Object? prefilledMedia = _undefined,
    bool? isSending,
    Object? imagePath = _undefined,
    Object? filePath = _undefined,

  }) {
    return ChatState(
      groupMessages: groupMessages ?? this.groupMessages,
      isLoading: isLoading ?? this.isLoading,
      error: error == _undefined ? this.error : error as String?,
      prefilledInputText: prefilledInputText == _undefined ? this.prefilledInputText : prefilledInputText as String?,
      prefilledMedia: prefilledMedia == _undefined ? this.prefilledMedia : prefilledMedia as ForwardMedia?,
      isSending: isSending ?? this.isSending,
      imagePath: imagePath == _undefined ? this.imagePath : imagePath as String?,
      filePath: filePath == _undefined ? this.filePath : filePath as String?,
    );
  }

  static const _undefined = Object();

  @override
  List<Object?> get props => [groupMessages, isLoading, error, prefilledInputText, prefilledMedia, isSending, imagePath, filePath];
}

class ForwardMedia {
  final String url;
  final String type;

  ForwardMedia({required this.url, required this.type});
}