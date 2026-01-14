import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/user_profile.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/repository/live_chat_repository.dart';
import 'chat_room_event.dart';
import 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final ChatRoomRepository _repository;

  ChatRoomBloc({required ChatRoomRepository repository})
    : _repository = repository,
      super(const ChatRoomState(roomId: '', isLoading: true)) {
    on<ChatRoomStarted>(_onStarted);
    on<ChatMessageSendRequested>(_onSendMessage);
    on<ChatTypingChanged>(_onTypingChanged);
    on<ChatImageSelected>(_onImageSelected);
    on<ChatImageCleared>(_onImageCleared);
    on<FriendRequestSent>(_onFriendRequestSent);
    on<FriendRemoveRequested>(_onFriendRemoveRequested);
    on<FriendStatusRequested>(_onFriendStatusRequested);
    on<ChatMessageDeleteRequested>(_onMessageDeleteRequested);
    on<ChatMessageDeleteForMeRequested>(_onDeleteForMe);
    on<ChatMessageStarToggled>(_onStarToggled);
    on<ChatMessageForwardRequested>(_onForwardMessage);
    on<ChatMessageReportToggled>(_onReportToggled);
    on<ChatMessagesUpdated>(_onChatMessagesUpdated);
    on<UserProfileRequested>(_onUserProfileRequested);
  }

  Future<void> _onUserProfileRequested(
    UserProfileRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    if (state.userProfiles.containsKey(event.userId)) {
      emit(
        state.copyWith(
          userProfile: state.userProfiles[event.userId],
          profileStatus: UserProfileStatus.loaded,
        ),
      );
      return;
    }

    emit(state.copyWith(profileStatus: UserProfileStatus.loading));

    try {
      final profile = await _repository.fetchUserProfile(event.userId);
      if (profile == null) {
        emit(state.copyWith(profileStatus: UserProfileStatus.error));
        return;
      }

      final updatedProfiles = Map<String, UserProfileData>.from(
        state.userProfiles,
      )..[event.userId] = profile;

      emit(
        state.copyWith(
          userProfiles: updatedProfiles,
          userProfile: profile,
          profileStatus: UserProfileStatus.loaded,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          profileStatus: UserProfileStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _onReportToggled(
    ChatMessageReportToggled event,
    Emitter<ChatRoomState> emit,
  ) async {
    final index = state.messages.indexWhere((m) => m.id == event.messageId);
    if (index == -1) return;

    final oldMsg = state.messages[index];

    final updatedMsg = oldMsg.copyWith(isReported: !oldMsg.isReported);

    final updatedMessages = List<ChatMessage>.from(state.messages);
    updatedMessages[index] = updatedMsg;

    emit(state.copyWith(messages: updatedMessages));

    try {
      await _repository.toggleReportMessage(
        messageId: event.messageId,
        reportedUserId: event.reportedUserId,
        reason: event.reason,
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onForwardMessage(
    ChatMessageForwardRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    await _repository.forwardMessage(
      messageId: event.messageId,
      targetRoomId: event.targetRoomId,
    );
  }

  Future<void> _onStarToggled(
    ChatMessageStarToggled event,
    Emitter<ChatRoomState> emit,
  ) async {
    final index = state.messages.indexWhere((m) => m.id == event.messageId);
    if (index == -1) return;

    final oldMsg = state.messages[index];

    final updatedMsg = oldMsg.copyWith(isStarred: !oldMsg.isStarred);

    final updatedMessages = List<ChatMessage>.from(state.messages);
    updatedMessages[index] = updatedMsg;

    emit(state.copyWith(messages: updatedMessages));

    try {
      await _repository.toggleSaveMessage(event.messageId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onDeleteForMe(
    ChatMessageDeleteForMeRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    final updatedMessages = state.messages
        .where((m) => m.id != event.messageId)
        .toList();

    emit(state.copyWith(messages: updatedMessages));

    try {
      await _repository.deleteMessageForMe(event.messageId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : (dateTime.hour == 0 ? 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Future<void> _onMessageDeleteRequested(
    ChatMessageDeleteRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    final updatedMessages = state.messages
        .where((m) => m.id != event.messageId)
        .toList();

    emit(state.copyWith(messages: updatedMessages));

    try {
      await _repository.deleteMessageForEveryone(event.messageId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void _onImageSelected(ChatImageSelected event, Emitter<ChatRoomState> emit) {
    emit(state.copyWith(pendingImage: event.imagePath, isTyping: true));
  }

  void _onImageCleared(ChatImageCleared event, Emitter<ChatRoomState> emit) {
    emit(state.copyWith(clearPendingImage: true, isTyping: false));
  }

  void _onTypingChanged(ChatTypingChanged event, Emitter<ChatRoomState> emit) {
    emit(state.copyWith(isTyping: event.isTyping));
  }

  Future<void> _onFriendStatusRequested(
    FriendStatusRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(state.copyWith(friendStatus: FriendStatus.loading));

    try {
      final data = await _repository.getFriendRequest(event.otherUserId);

      if (data == null) {
        emit(state.copyWith(friendStatus: FriendStatus.none));
        return;
      }

      if (data['status'] == 'accepted') {
        emit(
          state.copyWith(
            friendStatus: FriendStatus.accepted,
            friendRequestId: data['id'],
          ),
        );
        return;
      }

      if (data['status'] == 'pending') {
        final currentUserId = _repository.currentUserId;
        final isSender = data['sender_id'] == currentUserId;

        emit(
          state.copyWith(
            friendStatus: isSender
                ? FriendStatus.pendingSent
                : FriendStatus.pendingReceived,
            friendRequestId: data['id'],
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onFriendRequestSent(
    FriendRequestSent event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      await _repository.sendFriendRequest(event.otherUserId);

      if (!isClosed) {
        emit(
          state.copyWith(friendStatus: FriendStatus.pendingSent, error: null),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(error: e.toString()));
      }
    }
  }

  Future<void> _onFriendRemoveRequested(
    FriendRemoveRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    try {
      await _repository.removeFriend(event.requestId);

      if (!isClosed) {
        emit(
          state.copyWith(
            friendStatus: FriendStatus.none,
            friendRequestId: null,
            error: null,
          ),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(error: e.toString()));
      }
    }
  }

  Future<void> _onSendMessage(
    ChatMessageSendRequested event,
    Emitter<ChatRoomState> emit,
  ) async {
    if (event.text.trim().isEmpty && state.pendingImage == null) return;

    final now = DateTime.now();

    final localMessage = ChatMessage(
      id: now.millisecondsSinceEpoch.toString(),
      senderId: _repository.currentUserId,
      isSender: true,
      text: event.text.trim(),
      time: _formatTime(now),
      createdAt: now,
      isLocal: true,
    );

    emit(
      state.copyWith(
        messages: List<ChatMessage>.from(state.messages)..add(localMessage),
        isTyping: false,
        pendingImage: null,
      ),
    );

    try {
      await _repository.sendTextMessage(
        roomId: state.roomId,
        text: event.text.trim(),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  StreamSubscription<List<ChatMessage>>? _messagesSubscription;
  void _onChatMessagesUpdated(
    ChatMessagesUpdated event,
    Emitter<ChatRoomState> emit,
  ) {
    emit(state.copyWith(messages: event.messages, isLoading: false));

    for (final msg in event.messages) {
      final senderId = msg.senderId;
      if (senderId != null && !state.userProfiles.containsKey(senderId)) {
        add(UserProfileRequested(senderId));
      }
    }
  }

  Future<void> _onStarted(
    ChatRoomStarted event,
    Emitter<ChatRoomState> emit,
  ) async {
    emit(
      state.copyWith(
        roomId: event.roomId,
        messages: const [],
        isLoading: true,
        error: null,
      ),
    );

    await _messagesSubscription?.cancel();

    _messagesSubscription = _repository
        .streamMessages(roomId: event.roomId)
        .listen(
          (messages) {
            add(ChatMessagesUpdated(messages));
          },
          onError: (error) {
            emit(state.copyWith(isLoading: false, error: error.toString()));
          },
        );
  }

  @override
  Future<void> close() async {
    await _messagesSubscription?.cancel();
    return super.close();
  }
}
