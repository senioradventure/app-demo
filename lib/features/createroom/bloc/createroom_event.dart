part of 'createroom_bloc.dart';

@immutable
sealed class CreateroomEvent {}

class PickImageFromGalleryEvent extends CreateroomEvent {}

class ResetCreateRoomEvent extends CreateroomEvent {}

final class NameTextFieldCounterEvent extends CreateroomEvent {
  final int count;
  NameTextFieldCounterEvent(this.count);
}

final class DisDescriptionTextFieldCounterEvent extends CreateroomEvent {
  final int count;
  DisDescriptionTextFieldCounterEvent(this.count);
}

class SearchInterestEvent extends CreateroomEvent {
  final String query;
  SearchInterestEvent(this.query);
}

class AddInterestEvent extends CreateroomEvent {
  final String interest;
  AddInterestEvent(this.interest);
}

class RemoveInterestEvent extends CreateroomEvent {
  final String interest;
  RemoveInterestEvent(this.interest);
}


class LoadLocationsEvent extends CreateroomEvent {
  
}

class SearchLocationEvent extends CreateroomEvent {
  final String query;
  SearchLocationEvent(this.query);
}

class AddLocationEvent extends CreateroomEvent {
  final LocationModel location;
  AddLocationEvent(this.location);
}

class RemoveLocationEvent extends CreateroomEvent {}

class ConfirmCreateRoomEvent extends CreateroomEvent {
  final String roomName;
  final String description;

  ConfirmCreateRoomEvent({
    required this.roomName,
    required this.description,
  });
}
