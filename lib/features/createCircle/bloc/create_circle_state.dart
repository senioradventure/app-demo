part of 'create_circle_bloc.dart';

enum CreateCircleStatus {
  initial,
  loadingFriends,
  friendsLoaded,
  submitting,
  success,
  failure,
}

class CreateCircleState extends Equatable {
  final CreateCircleStatus status;
  final List<Friend> friends;
  final List<Friend> filteredFriends;
  final Set<String> selectedFriendIds;
  final String? errorMessage;

  const CreateCircleState({
    this.status = CreateCircleStatus.initial,
    this.friends = const [],
    this.filteredFriends = const [],
    this.selectedFriendIds = const {},
    this.errorMessage,
  });

  CreateCircleState copyWith({
    CreateCircleStatus? status,
    List<Friend>? friends,
    List<Friend>? filteredFriends,
    Set<String>? selectedFriendIds,
    String? errorMessage,
  }) {
    return CreateCircleState(
      status: status ?? this.status,
      friends: friends ?? this.friends,
      filteredFriends: filteredFriends ?? this.filteredFriends,
      selectedFriendIds: selectedFriendIds ?? this.selectedFriendIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    status,
    friends,
    filteredFriends,
    selectedFriendIds,
    errorMessage ?? '',
  ];
}
