import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repository/create_circle_repository.dart';
import '../model/friend_model.dart';

part 'create_circle_event.dart';
part 'create_circle_state.dart';

class CreateCircleBloc extends Bloc<CreateCircleEvent, CreateCircleState> {
  final CreateCircleRepository _repository;

  CreateCircleBloc({required CreateCircleRepository repository})
    : _repository = repository,
      super(const CreateCircleState()) {
    on<LoadFriends>(_onLoadFriends);
    on<ToggleFriendSelection>(_onToggleFriendSelection);
  }

  Future<void> _onLoadFriends(
    LoadFriends event,
    Emitter<CreateCircleState> emit,
  ) async {
    emit(state.copyWith(status: CreateCircleStatus.loading));
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        emit(
          state.copyWith(
            status: CreateCircleStatus.failure,
            errorMessage: "User not logged in",
          ),
        );
        return;
      }
      final friends = await _repository.fetchFriends(userId);
      emit(
        state.copyWith(status: CreateCircleStatus.success, friends: friends),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateCircleStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onToggleFriendSelection(
    ToggleFriendSelection event,
    Emitter<CreateCircleState> emit,
  ) {
    final updatedSelection = Set<String>.from(state.selectedFriendIds);
    if (updatedSelection.contains(event.friendId)) {
      updatedSelection.remove(event.friendId);
    } else {
      updatedSelection.add(event.friendId);
    }
    emit(state.copyWith(selectedFriendIds: updatedSelection));
  }
}
