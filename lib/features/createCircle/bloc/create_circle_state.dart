part of 'create_circle_bloc.dart';

import 'package:image_picker/image_picker.dart';

enum CreateCircleStatus { initial, loading, success, failure }

final class CreateCircleState extends Equatable {
  const CreateCircleState({
    this.status = CreateCircleStatus.initial,
    this.name = '',
    this.image,
    this.errorMessage,
  });

  final CreateCircleStatus status;
  final String name;
  final XFile? image;
  final String? errorMessage;

  CreateCircleState copyWith({
    CreateCircleStatus? status,
    String? name,
    XFile? image,
    String? errorMessage,
  }) {
    return CreateCircleState(
      status: status ?? this.status,
      name: name ?? this.name,
      image: image ?? this.image,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, name, image, errorMessage];
}
