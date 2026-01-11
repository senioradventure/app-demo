import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/view_friends/bloc/view_friends_event.dart';
import 'package:senior_circle/features/view_friends/bloc/view_friends_state.dart';
import 'package:senior_circle/features/view_friends/models/friends_model.dart';
import '../repository/view_friends_repository.dart';

class ViewFriendsBloc extends Bloc<ViewFriendsEvent, ViewFriendsState> {
  final ViewFriendsRepository repository;

  List<Friend> _allFriends = [];

  ViewFriendsBloc(this.repository) : super(ViewFriendsInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<SearchFriends>(_onSearchFriends);
  }

  Future<void> _onLoadFriends(
    LoadFriends event,
    Emitter<ViewFriendsState> emit,
  ) async {
    emit(ViewFriendsLoading());

    try {
      final userId = repository.currentUserId;
      if (userId == null) {
        emit(ViewFriendsError('User not logged in'));
        return;
      }

      _allFriends = await repository.getFriends(userId);

      emit(ViewFriendsLoaded(_allFriends));
    } catch (e) {
      emit(ViewFriendsError('Failed to load friends'));
    }
  }

  void _onSearchFriends(
    SearchFriends event,
    Emitter<ViewFriendsState> emit,
  ) {
    final query = event.query.toLowerCase();

    final filtered = _allFriends.where((friend) {
      return friend.name.toLowerCase().contains(query);
    }).toList();

    emit(ViewFriendsLoaded(filtered));
  }
}


