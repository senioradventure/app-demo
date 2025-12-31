part of 'create_circle_bloc.dart';

enum CreateCircleStatus { initial, loading, success, failure }

class CreateCircleState extends Equatable {
  final CreateCircleStatus status;
  final List<Friend> friends;
  final Set<String> selectedFriendIds;
  final String? errorMessage;

  const CreateCircleState({
    this.status = CreateCircleStatus.initial,
    this.friends = const [],
    this.selectedFriendIds = const {},
    this.errorMessage,
  });

  CreateCircleState copyWith({
    CreateCircleStatus? status,
    List<Friend>? friends,
    Set<String>? selectedFriendIds,
    String? errorMessage,
  }) {
    return CreateCircleState(
      status: status ?? this.status,
      friends: friends ?? this.friends,
      selectedFriendIds: selectedFriendIds ?? this.selectedFriendIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    status,
    friends,
    selectedFriendIds,
    errorMessage ?? '',
  ];
}
