part of 'create_circle_bloc.dart';

import 'package:image_picker/image_picker.dart';

sealed class CreateCircleEvent extends Equatable {
  const CreateCircleEvent();

  @override
  List<Object?> get props => [];
}

final class CreateCircleNameChanged extends CreateCircleEvent {
  final String name;

  const CreateCircleNameChanged(this.name);

  @override
  List<Object> get props => [name];
}

final class CreateCircleImagePicked extends CreateCircleEvent {
  final XFile? image;

  const CreateCircleImagePicked(this.image);

  @override
  List<Object?> get props => [image];
}

final class CreateCircleSubmitted extends CreateCircleEvent {
  const CreateCircleSubmitted();
}
