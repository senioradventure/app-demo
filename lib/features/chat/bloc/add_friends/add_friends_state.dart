import 'package:equatable/equatable.dart';
import '../../../view_friends/models/friends_model.dart';

enum AddFriendsStatus {
  initial,
  loading,
  success,
  failure,
  submitting,
  submitted,
}

class AddFriendsState extends Equatable {
  final AddFriendsStatus status;
  final List<Friend> allFriends;
  final List<Friend> filteredFriends;
  final Set<String> selectedFriendIds;
  final String? errorMessage;

  const AddFriendsState({
    this.status = AddFriendsStatus.initial,
    this.allFriends = const [],
    this.filteredFriends = const [],
    this.selectedFriendIds = const {},
    this.errorMessage,
  });

  AddFriendsState copyWith({
    AddFriendsStatus? status,
    List<Friend>? allFriends,
    List<Friend>? filteredFriends,
    Set<String>? selectedFriendIds,
    String? errorMessage,
  }) {
    return AddFriendsState(
      status: status ?? this.status,
      allFriends: allFriends ?? this.allFriends,
      filteredFriends: filteredFriends ?? this.filteredFriends,
      selectedFriendIds: selectedFriendIds ?? this.selectedFriendIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allFriends,
    filteredFriends,
    selectedFriendIds,
    errorMessage,
  ];
}
