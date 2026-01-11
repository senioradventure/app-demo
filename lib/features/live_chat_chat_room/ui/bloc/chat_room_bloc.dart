import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:senior_circle/features/live_chat_chat_room/models/chat_messages.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/repository/live_chat_repository.dart';
import 'chat_room_event.dart';
import 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final ChatRoomRepository _repository;
  StreamSubscription<List<ChatMessage>>? _sub;

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
    try {
      if (event.text.trim().isEmpty && state.pendingImage == null) return;

      await _repository.sendTextMessage(
        roomId: state.roomId,
        text: event.text.trim(),
      );

      emit(
        state.copyWith(
          isTyping: false,
          pendingImage: null,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }



  void _onStarted(
    ChatRoomStarted event,
    Emitter<ChatRoomState> emit,
  ) {
    emit(
      state.copyWith(
        roomId: event.roomId,
        isLoading: true,
        error: null,
      ),
    );

    _sub?.cancel();

    _sub = _repository
        .streamMessages(roomId: event.roomId)
        .listen(
          (messages) {
            emit(
              state.copyWith(
                messages: messages,
                isLoading: false,
              ),
            );
          },
          onError: (e) {
            emit(
              state.copyWith(
                isLoading: false,
                error: e.toString(),
              ),
            );
          },
        );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
