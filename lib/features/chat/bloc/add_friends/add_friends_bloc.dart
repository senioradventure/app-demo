import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/chat_details_repository.dart';
import 'add_friends_event.dart';
import 'add_friends_state.dart';

class AddFriendsBloc extends Bloc<AddFriendsEvent, AddFriendsState> {
  final ChatDetailsRepository _repository;

  AddFriendsBloc({required ChatDetailsRepository repository})
    : _repository = repository,
      super(const AddFriendsState()) {
    on<LoadFriendsEvent>(_onLoadFriends);
    on<SearchFriendsEvent>(_onSearchFriends);
    on<ToggleFriendSelectionEvent>(_onToggleFriendSelection);
    on<AddSelectedMembersEvent>(_onAddSelectedMembers);
  }

  Future<void> _onLoadFriends(
    LoadFriendsEvent event,
    Emitter<AddFriendsState> emit,
  ) async {
    emit(state.copyWith(status: AddFriendsStatus.loading));
    try {
      final friends = await _repository.getMyFriends();

      // Filter out friends who are already members
      final currentMemberIds = event.currentMembers
          .map((m) => m.userId)
          .toSet();
      final potentialMembers = friends
          .where((f) => !currentMemberIds.contains(f.id))
          .toList();

      emit(
        state.copyWith(
          status: AddFriendsStatus.success,
          allFriends: potentialMembers,
          filteredFriends: potentialMembers,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AddFriendsStatus.failure,
          errorMessage: 'Failed to load friends: $e',
        ),
      );
    }
  }

  void _onSearchFriends(
    SearchFriendsEvent event,
    Emitter<AddFriendsState> emit,
  ) {
    if (event.query.isEmpty) {
      emit(state.copyWith(filteredFriends: state.allFriends));
      return;
    }

    final lowerQuery = event.query.toLowerCase();
    final filtered = state.allFriends.where((friend) {
      return friend.name.toLowerCase().contains(lowerQuery);
    }).toList();

    emit(state.copyWith(filteredFriends: filtered));
  }

  void _onToggleFriendSelection(
    ToggleFriendSelectionEvent event,
    Emitter<AddFriendsState> emit,
  ) {
    final selectedIds = Set<String>.from(state.selectedFriendIds);
    if (selectedIds.contains(event.friendId)) {
      selectedIds.remove(event.friendId);
    } else {
      selectedIds.add(event.friendId);
    }
    emit(state.copyWith(selectedFriendIds: selectedIds));
  }

  Future<void> _onAddSelectedMembers(
    AddSelectedMembersEvent event,
    Emitter<AddFriendsState> emit,
  ) async {
    if (state.selectedFriendIds.isEmpty) return;

    emit(state.copyWith(status: AddFriendsStatus.submitting));
    try {
      await _repository.addMembersToCircle(
        event.chatId,
        state.selectedFriendIds.toList(),
      );
      emit(state.copyWith(status: AddFriendsStatus.submitted));
    } catch (e) {
      emit(
        state.copyWith(
          status: AddFriendsStatus.failure,
          errorMessage: 'Failed to add members: $e',
        ),
      );
    }
  }
}
