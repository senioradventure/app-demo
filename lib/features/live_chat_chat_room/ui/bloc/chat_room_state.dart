import 'package:equatable/equatable.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/user_profile.dart';

enum FriendStatus { none, loading, pendingSent, pendingReceived, accepted }

enum UserProfileStatus { initial, loading, loaded, error }

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
  final UserProfileStatus profileStatus;
  final UserProfileData? userProfile;
  final Map<String, UserProfileData> userProfiles;

  const ChatRoomState({
    required this.roomId,
    this.messages = const [],
    this.isLoading = false,
    this.isTyping = false,
    this.pendingImage,
    this.error,
    this.friendStatus = FriendStatus.none,
    this.friendRequestId,
    this.profileStatus = UserProfileStatus.initial,
    this.userProfile,
    this.userProfiles = const {},
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
    UserProfileStatus? profileStatus,
    UserProfileData? userProfile,
    Map<String, UserProfileData>? userProfiles,
  }) {
    return ChatRoomState(
      roomId: roomId ?? this.roomId,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isTyping: isTyping ?? this.isTyping,
      pendingImage: clearPendingImage
          ? null
          : (pendingImage ?? this.pendingImage),
      error: error ?? this.error,
      friendStatus: friendStatus ?? this.friendStatus,
      friendRequestId: friendRequestId ?? this.friendRequestId,
      profileStatus: profileStatus ?? this.profileStatus,
      userProfile: userProfile ?? this.userProfile,
      userProfiles: userProfiles ?? this.userProfiles,
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
    profileStatus,
    userProfile,
    userProfiles,
  ];
}
