part of 'live_chat_home_bloc.dart';

sealed class LiveChatHomeState extends Equatable {
  const LiveChatHomeState();
  
  @override
  List<Object> get props => [];
}

final class LiveChatHomeInitial extends LiveChatHomeState {}
