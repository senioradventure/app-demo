part of 'chat_room_bloc.dart';

class ChatRoomState extends Equatable {
  final List<ChatMessage> messages;  
  final bool isLoading;              
  final bool isSending;               
  final String? pendingImage;        
  final String? error;                
  const ChatRoomState({
    this.messages = const [],
    this.isLoading = false,
    this.isSending = false,
    this.pendingImage,
    this.error,
  });

  ChatRoomState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isSending,
    String? pendingImage,
    String? error,
  }) {
    return ChatRoomState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      pendingImage: pendingImage,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        isLoading,
        isSending,
        pendingImage,
        error,
      ];
}
