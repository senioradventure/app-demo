import 'package:equatable/equatable.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';

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

class FriendRequestSent extends ChatRoomEvent {
  final String otherUserId;
  const FriendRequestSent(this.otherUserId);

  @override
  List<Object?> get props => [otherUserId];
}

class FriendRemoveRequested extends ChatRoomEvent {
  final String requestId;
  const FriendRemoveRequested(this.requestId);

  @override
  List<Object?> get props => [requestId];
}

class FriendStatusRequested extends ChatRoomEvent {
  final String otherUserId;
  const FriendStatusRequested(this.otherUserId);

  @override
  List<Object?> get props => [otherUserId];
}

class UserProfileRequested extends ChatRoomEvent {
  final String userId;
  const UserProfileRequested(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ChatMessageDeleteRequested extends ChatRoomEvent {
  final String messageId;

  const ChatMessageDeleteRequested({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

class ChatMessageDeleteForMeRequested extends ChatRoomEvent {
  final String messageId;

  const ChatMessageDeleteForMeRequested({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

class ChatMessageStarToggled extends ChatRoomEvent {
  final String messageId;

  ChatMessageStarToggled({required this.messageId});
}

class ChatMessageForwardRequested extends ChatRoomEvent {
  final String messageId;
  final String targetRoomId;

  const ChatMessageForwardRequested({
    required this.messageId,
    required this.targetRoomId,
  });
}

class ChatMessageReportToggled extends ChatRoomEvent {
  final String messageId;
  final String reportedUserId;
  final String? reason;

  const ChatMessageReportToggled({
    required this.messageId,
    required this.reportedUserId,
    this.reason,
  });

  @override
  List<Object?> get props => [messageId, reportedUserId, reason];
}

class ChatMessagesUpdated extends ChatRoomEvent {
  final List<ChatMessage> messages;

  const ChatMessagesUpdated(this.messages);

  @override
  List<Object?> get props => [messages];
}
