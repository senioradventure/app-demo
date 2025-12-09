part of 'chatroomdetails_bloc.dart';

sealed class ChatroomdetailsState extends Equatable {
  const ChatroomdetailsState();

  @override
  List<Object> get props => [];
}

class ChatroomdetailsInitial extends ChatroomdetailsState {
  final bool showAll;

  const ChatroomdetailsInitial({this.showAll = false});

  ChatroomdetailsInitial copyWith({bool? showAll}) {
    return ChatroomdetailsInitial(showAll: showAll ?? this.showAll);
  }

  @override
  List<Object> get props => [showAll];
}
