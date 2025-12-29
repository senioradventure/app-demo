
import 'package:senior_circle/features/view_friends/models/friends_model.dart';

abstract class ViewFriendsState {}

class ViewFriendsInitial extends ViewFriendsState {}

class ViewFriendsLoading extends ViewFriendsState {}

class ViewFriendsLoaded extends ViewFriendsState {
  final List<Friend> friends;

  ViewFriendsLoaded(this.friends);
}

class ViewFriendsEmpty extends ViewFriendsState {}

class ViewFriendsError extends ViewFriendsState {
  final String message;

  ViewFriendsError(this.message);
}
