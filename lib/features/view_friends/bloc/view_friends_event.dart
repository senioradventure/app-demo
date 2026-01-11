abstract class ViewFriendsEvent {}

class LoadFriends extends ViewFriendsEvent {}

class SearchFriends extends ViewFriendsEvent {
  final String query;

  SearchFriends(this.query);
}

class StartChatWithFriend extends ViewFriendsEvent {
  final String friendId;
  StartChatWithFriend(this.friendId);
}
