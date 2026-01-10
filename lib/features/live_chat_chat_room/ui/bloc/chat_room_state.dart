import 'package:equatable/equatable.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';

class ChatRoomState extends Equatable {
  
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isTyping;
  final String? pendingImage;
  final String? error;
  final String roomId;


  const ChatRoomState({
    required this.roomId,
    this.messages = const [],
    this.isLoading = false,
    this.isTyping = false,
    this.pendingImage,
    this.error,
  });

  ChatRoomState copyWith({
    String? roomId,
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isTyping,
    String? pendingImage,
    bool clearPendingImage = false,
    String? error,
  }) {
    return ChatRoomState(
      roomId: roomId ?? this.roomId,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      pendingImage: clearPendingImage
        ? null
        : (pendingImage ?? this.pendingImage),
      isTyping: isTyping ?? this.isTyping,
      error: error,
    );
  }

  @override
  List<Object?> get props => [roomId,messages, isLoading,isTyping,pendingImage, error];
}
