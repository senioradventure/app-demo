import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/repository/live_chat_repository.dart';
import 'chat_room_event.dart';
import 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final ChatRoomRepository _repository;

  ChatRoomBloc({required ChatRoomRepository repository})
      : _repository = repository,
        super(const ChatRoomState(
          roomId: '',
          isLoading: true,
        )) {
    on<ChatRoomStarted>(_onStarted);
    on<ChatMessageSendRequested>(_onSendMessage);
    on<ChatTypingChanged>(_onTypingChanged);
    on<ChatImageSelected>(_onImageSelected);
    on<ChatImageCleared>(_onImageCleared);
    on<FriendRequestSent>(_onFriendRequestSent);
    on<FriendRemoveRequested>(_onFriendRemoveRequested);
    on<FriendStatusRequested>(_onFriendStatusRequested);
    on<UserProfileRequested>(_onUserProfileRequested);
    on<ChatMessageDeleteRequested>(_onMessageDeleteRequested);
    on<ChatMessageDeleteForMeRequested>(_onDeleteForMe);


  }
  Future<void> _onDeleteForMe(
  ChatMessageDeleteForMeRequested event,
  Emitter<ChatRoomState> emit,
) async {
  // ✅ instant UI update
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


Future<void> _onUserProfileRequested(
  UserProfileRequested event,
  Emitter<ChatRoomState> emit,
) async {
  try {
    final profile = await _repository.getUserProfile(event.userId);

    emit(state.copyWith(otherUserProfile: profile));
  } catch (e) {
    emit(state.copyWith(error: e.toString()));
  }
}


  void _onImageSelected(
    ChatImageSelected event,
    Emitter<ChatRoomState> emit,
  ) {
    emit(
      state.copyWith(
        pendingImage: event.imagePath,
        isTyping: true,
      ),
    );
  }

  void _onImageCleared(
    ChatImageCleared event,
    Emitter<ChatRoomState> emit,
  ) {
    emit(
      state.copyWith(
        clearPendingImage: true,
        isTyping: false,
      ),
    );
  }



  void _onTypingChanged(
    ChatTypingChanged event,
    Emitter<ChatRoomState> emit,
  ) {
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
      emit(state.copyWith(friendStatus: FriendStatus.accepted,friendRequestId: data['id'],));
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
      emit(state.copyWith(
        friendStatus: FriendStatus.pendingSent,
        error: null,
      ));
    }
  } catch (e) {
    if (!isClosed) {
      emit(state.copyWith(
        error: e.toString(),
      ));
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
      emit(
        state.copyWith(
          error: e.toString(),
        ),
      );
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




  Future<void> _onStarted(
  ChatRoomStarted event,
  Emitter<ChatRoomState> emit,
) async {
  emit(state.copyWith(
    roomId: event.roomId,
    error: null,
  ));

  await emit.forEach<List<ChatMessage>>(
    _repository.streamMessages(roomId: event.roomId),
    onData: (messages) {
      return state.copyWith(
        messages: messages,
        isLoading: false,
      );
    },
    onError: (error, stackTrace) {
      return state.copyWith(
        isLoading: false,
        error: error.toString(),
      );
    },
  );
}


  @override
  Future<void> close() {
    return super.close();
  }
}
