part of 'chatroomdetails_bloc.dart';

sealed class ChatroomdetailsEvent extends Equatable {
  const ChatroomdetailsEvent();

  @override
  List<Object> get props => [];
}

class ToggleShowMoreEvent extends ChatroomdetailsEvent {}
