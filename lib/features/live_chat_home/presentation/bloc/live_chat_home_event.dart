part of 'live_chat_home_bloc.dart';

abstract class LiveChatHomeEvent extends Equatable {
  const LiveChatHomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchLocationsEvent extends LiveChatHomeEvent {}

class FetchRoomsEvent extends LiveChatHomeEvent {}

class UpdateLocationFilterEvent extends LiveChatHomeEvent {
  final String? location;
  const UpdateLocationFilterEvent(this.location);

  @override
  List<Object?> get props => [location];
}

class UpdateInterestFilterEvent extends LiveChatHomeEvent {
  final String? interest;
  const UpdateInterestFilterEvent(this.interest);

  @override
  List<Object?> get props => [interest];
}

class UpdateSearchEvent extends LiveChatHomeEvent {
  final String search;
  const UpdateSearchEvent(this.search);

  @override
  List<Object?> get props => [search];
}
