import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../repository/create_circle_repository.dart';
import '../model/friend_model.dart';

part 'create_circle_event.dart';
part 'create_circle_state.dart';

class CreateCircleBloc extends Bloc<CreateCircleEvent, CreateCircleState> {
  final CreateCircleRepository _repository;

  CreateCircleBloc({required CreateCircleRepository repository})
    : _repository = repository,
      super(const CreateCircleState()) {
    on<LoadCircleFriends>(_onLoadFriends);
    on<ToggleFriendSelection>(_onToggleFriendSelection);
    on<SearchFriends>(_onSearchFriends);
    on<CreateCircle>(_onCreateCircle);
  }

  Future<void> _onLoadFriends(
    LoadCircleFriends event,
    Emitter<CreateCircleState> emit,
  ) async {
    emit(state.copyWith(status: CreateCircleStatus.loadingFriends));
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
        state.copyWith(
          status: CreateCircleStatus.friendsLoaded,
          friends: friends,
          filteredFriends: friends,
        ),
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

  void _onSearchFriends(SearchFriends event, Emitter<CreateCircleState> emit) {
    if (event.query.isEmpty) {
      emit(state.copyWith(filteredFriends: state.friends));
    } else {
      final filtered = state.friends
          .where(
            (friend) => friend.fullName.toLowerCase().contains(
              event.query.toLowerCase(),
            ),
          )
          .toList();
      emit(state.copyWith(filteredFriends: filtered));
    }
  }

  Future<void> _onCreateCircle(
    CreateCircle event,
    Emitter<CreateCircleState> emit,
  ) async {
    emit(state.copyWith(status: CreateCircleStatus.submitting));
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

      await _repository.createCircle(
        name: event.name,
        adminId: userId,
        imageFile: event.image,
        friendIds: state.selectedFriendIds.toList(),
      );

      emit(state.copyWith(status: CreateCircleStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateCircleStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
