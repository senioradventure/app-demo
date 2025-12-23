part of 'create_circle_bloc.dart';

import 'package:image_picker/image_picker.dart';

enum CreateCircleStatus { initial, loading, success, failure }

final class CreateCircleState extends Equatable {


  final CreateCircleStatus status;
  final String name;
  final XFile? image;
  final String? errorMessage;
  final List<Map<String, dynamic>> friends;
  final List<String> selectedFriendIds;
  final bool isLoadingFriends;

  const CreateCircleState({
    this.status = CreateCircleStatus.initial,
    this.name = '',
    this.image,
    this.errorMessage,
    this.friends = const [],
    this.selectedFriendIds = const [],
    this.isLoadingFriends = false,
  });

  CreateCircleState copyWith({
    CreateCircleStatus? status,
    String? name,
    XFile? image,
    String? errorMessage,
    List<Map<String, dynamic>>? friends,
    List<String>? selectedFriendIds,
    bool? isLoadingFriends,
  }) {
    return CreateCircleState(
      status: status ?? this.status,
      name: name ?? this.name,
      image: image ?? this.image,
      errorMessage: errorMessage ?? this.errorMessage,
      friends: friends ?? this.friends,
      selectedFriendIds: selectedFriendIds ?? this.selectedFriendIds,
      isLoadingFriends: isLoadingFriends ?? this.isLoadingFriends,
    );
  }

  @override
  List<Object?> get props => [
    status,
    name,
    image,
    errorMessage,
    friends,
    selectedFriendIds,
    isLoadingFriends,
  ];
}
