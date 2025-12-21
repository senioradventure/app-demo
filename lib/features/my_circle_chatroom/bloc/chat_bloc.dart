import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/constants/group_messages.dart';
import 'package:senior_circle/core/constants/inividual_messages.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/utils/reaction_utils.dart';
import 'chat_event.dart';
import 'chat_state.dart';
import '../models/message_model.dart';
import 'package:uuid/uuid.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
   final _uuid = const Uuid(); 
  ChatBloc() : super(const ChatState(messages: [])) {
    on<LoadMessages>(_onLoadMessages);
    on<LoadGroupMessages>(_onLoadGroupMessages);
    on<SendMessage>(_onSendMessage);
    on<SendGroupMessage>(_onSendGroupMessage);
    on<DeleteMessage>(_onDeleteMessage);
    on<ToggleReaction>(_onToggleReaction);
    on<ToggleStar>(_onToggleStar);
  }
 
  void _onLoadMessages(
    LoadMessages event,
    Emitter<ChatState> emit,
  ) {
    emit(state.copyWith(isLoading: true));
    final messages = individualMessages
      .map((e) => Message.fromMap(e))
      .toList();

    emit(
      state.copyWith(
        messages: messages,
        isLoading: false,
      ),
    );
  }

  void _onLoadGroupMessages(
  LoadGroupMessages event,
  Emitter<ChatState> emit,
) {
  emit(state.copyWith(isLoading: true));

  final messages = groupMessages
      .map((e) => GroupMessage.fromMap(e))
      .toList();

  emit(
    state.copyWith(
      groupMessages: messages,
      isLoading: false,
    ),
  );
}



  void _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) {
    const currentUserId = 'you';
    final newMessage = Message(
      id:_uuid.v4(),
      senderId: currentUserId,
      senderName: 'You',
      text: event.text,
      imagePath: event.imagePath,
      time: DateTime.now().toString(),
    );

    emit(
      state.copyWith(
        messages: [...state.messages, newMessage],
      ),
    );
  }

void _onSendGroupMessage(
  SendGroupMessage event,
  Emitter<ChatState> emit,
) {
   const currentUserId = 'you';

  if ((event.text == null || event.text!.trim().isEmpty) &&
      event.imagePath == null) {
    return;
  }
  final newMessage = GroupMessage(
    id: _uuid.v4(),
    senderId: currentUserId,
    senderName: 'You',
    text: event.text,
    imagePath: event.imagePath,
    time: DateTime.now().toString(),
    avatar: 'assets/images/user_placeholder.png',
    replies: [],
    reactions: [],
  );

  emit(
    state.copyWith(
      groupMessages: [...state.groupMessages, newMessage],
    ),
  );
}


  void _onDeleteMessage(
    DeleteMessage event,
    Emitter<ChatState> emit,
  ) {
    final updatedMessages =
        state.messages.where((m) => m.id != event.messageId).toList();

    emit(state.copyWith(messages: updatedMessages));
  }


void _onToggleReaction(
  ToggleReaction event,
  Emitter<ChatState> emit,
) {
  final updatedMessages = state.messages.map((message) {
    if (message.id != event.messageId) return message;

    return toggleReaction(
      message: message,
      emoji: event.emoji,
      userId: event.userId,
    );
  }).toList();

  emit(state.copyWith(messages: updatedMessages));
}


  void _onToggleStar(
    ToggleStar event,
    Emitter<ChatState> emit,
  ) {
    // star logic 
  }
}
