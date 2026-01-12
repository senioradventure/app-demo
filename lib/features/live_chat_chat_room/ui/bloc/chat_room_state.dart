import 'package:equatable/equatable.dart';
import 'package:senior_circle/features/individual_chat/model/individual_user_profile_model.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/user_profiles.dart';

enum FriendStatus { none, loading, pendingSent, pendingReceived, accepted }

enum MessageAction { star, report, share, deleteForMe, deleteForEveryone }

class ChatRoomState extends Equatable {
  final List<ChatMessage> messages;
  final bool isLoading;
  final bool isTyping;
  final String? pendingImage;
  final String? error;
  final String roomId;
  final FriendStatus friendStatus;
  final String? friendRequestId;
  final ChatUserProfile? otherUserProfile;

  const ChatRoomState({
    required this.roomId,
    this.messages = const [],
    this.isLoading = false,
    this.isTyping = false,
    this.pendingImage,
    this.error,
    this.friendStatus = FriendStatus.none,
    this.friendRequestId,
    this.otherUserProfile,
  });

  ChatRoomState copyWith({
    String? roomId,
    List<ChatMessage>? messages,
    bool? isLoading,
    bool? isTyping,
    String? pendingImage,
    bool clearPendingImage = false,
    String? error,
    FriendStatus? friendStatus,
    String? friendRequestId,
    ChatUserProfile? otherUserProfile,
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
      friendStatus: friendStatus ?? this.friendStatus,
      friendRequestId: friendRequestId ?? this.friendRequestId,
      otherUserProfile: otherUserProfile ?? this.otherUserProfile,
    );
  }

  @override
  List<Object?> get props => [
    roomId,
    messages,
    isLoading,
    isTyping,
    pendingImage,
    error,
    friendStatus,
    friendRequestId,
    otherUserProfile,
  ];
}
