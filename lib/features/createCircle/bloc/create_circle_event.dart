part of 'create_circle_bloc.dart';

abstract class CreateCircleEvent extends Equatable {
  const CreateCircleEvent();

  @override
  List<Object> get props => [];
}

class LoadFriends extends CreateCircleEvent {}

class ToggleFriendSelection extends CreateCircleEvent {
  final String friendId;

  const ToggleFriendSelection(this.friendId);

  @override
  List<Object> get props => [friendId];
}
