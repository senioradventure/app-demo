part of 'create_circle_bloc.dart';

abstract class CreateCircleEvent extends Equatable {
  const CreateCircleEvent();

  @override
  List<Object> get props => [];
}

class LoadCircleFriends extends CreateCircleEvent {}

class ToggleFriendSelection extends CreateCircleEvent {
  final String friendId;

  const ToggleFriendSelection(this.friendId);

  @override
  List<Object> get props => [friendId];
}

class CreateCircle extends CreateCircleEvent {
  final String name;
  final File? image;

  const CreateCircle({required this.name, this.image});

  @override
  List<Object> get props => [name, image ?? ''];
}
