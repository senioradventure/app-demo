import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/features/createCircle/repositories/circle_repository.dart';

part 'create_circle_event.dart';
part 'create_circle_state.dart';

class CreateCircleBloc extends Bloc<CreateCircleEvent, CreateCircleState> {
  final CircleRepository _repository;

  CreateCircleBloc({required CircleRepository repository})
    : _repository = repository,
      super(const CreateCircleState()) {
    on<CreateCircleNameChanged>(_onNameChanged);
    on<CreateCircleImagePicked>(_onImagePicked);
    on<CreateCircleSubmitted>(_onSubmitted);
  }

  void _onNameChanged(
    CreateCircleNameChanged event,
    Emitter<CreateCircleState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onImagePicked(
    CreateCircleImagePicked event,
    Emitter<CreateCircleState> emit,
  ) {
    emit(state.copyWith(image: event.image));
  }

  Future<void> _onSubmitted(
    CreateCircleSubmitted event,
    Emitter<CreateCircleState> emit,
  ) async {
    if (state.name.isEmpty) {
      emit(state.copyWith(errorMessage: 'Please enter a circle name'));
      return;
    }

    emit(state.copyWith(status: CreateCircleStatus.loading));

    try {
      String? imageUrl;
      if (state.image != null) {
        imageUrl = await _repository.uploadImage(File(state.image!.path));
      }

      final String? circleId = await _repository.createCircleInDb(
        state.name,
        imageUrl,
      );

      if (circleId != null) {
        await _repository.addMembersToCircle(circleId);
        emit(state.copyWith(status: CreateCircleStatus.success));
      } else {
        emit(
          state.copyWith(
            status: CreateCircleStatus.failure,
            errorMessage: 'Failed to create circle. Please try again.',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateCircleStatus.failure,
          errorMessage: 'An unexpected error occurred: $e',
        ),
      );
    }
  }
}
