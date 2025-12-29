import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/constants/friends_list.dart';
import 'package:senior_circle/features/view_friends/bloc/view_friends_event.dart';
import 'package:senior_circle/features/view_friends/bloc/view_friends_state.dart';
import 'package:senior_circle/features/view_friends/models/friends_model.dart';

class ViewFriendsBloc extends Bloc<ViewFriendsEvent, ViewFriendsState> {
  List<Friend> _allFriends = [];

  ViewFriendsBloc() : super(ViewFriendsInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<SearchFriends>(_onSearchFriends);
  }

  Future<void> _onLoadFriends(
    LoadFriends event,
    Emitter<ViewFriendsState> emit,
  ) async {
    emit(ViewFriendsLoading());

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      _allFriends = friends; 
      emit(ViewFriendsLoaded(_allFriends));
    } catch (e) {
      emit(ViewFriendsError('Failed to load friends'));
    }
  }

  void _onSearchFriends(
    SearchFriends event,
    Emitter<ViewFriendsState> emit,
  ) {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(ViewFriendsLoaded(_allFriends));
      return;
    }

    final filtered = _allFriends.where((friend) {
      return friend.name.toLowerCase().contains(query);
    }).toList();

    emit(ViewFriendsLoaded(filtered));
  }
}
