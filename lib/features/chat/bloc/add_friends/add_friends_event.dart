import 'package:equatable/equatable.dart';

import '../../models/chat_details_models.dart';

abstract class AddFriendsEvent extends Equatable {
  const AddFriendsEvent();

  @override
  List<Object> get props => [];
}

class LoadFriendsEvent extends AddFriendsEvent {
  final List<ChatMember> currentMembers;

  const LoadFriendsEvent({required this.currentMembers});

  @override
  List<Object> get props => [currentMembers];
}

class SearchFriendsEvent extends AddFriendsEvent {
  final String query;

  const SearchFriendsEvent(this.query);

  @override
  List<Object> get props => [query];
}

class ToggleFriendSelectionEvent extends AddFriendsEvent {
  final String friendId;

  const ToggleFriendSelectionEvent(this.friendId);

  @override
  List<Object> get props => [friendId];
}

class AddSelectedMembersEvent extends AddFriendsEvent {
  final String chatId;

  const AddSelectedMembersEvent(this.chatId);

  @override
  List<Object> get props => [chatId];
}
