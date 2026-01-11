import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/my_circle_home/models/my_circle_model.dart';
import 'package:senior_circle/features/view_friends/bloc/view_friends_event.dart';
import 'package:senior_circle/features/view_friends/bloc/view_friends_state.dart';
import 'package:senior_circle/features/view_friends/models/friends_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repository/view_friends_repository.dart';

class ViewFriendsBloc extends Bloc<ViewFriendsEvent, ViewFriendsState> {
  final ViewFriendsRepository repository;

  List<Friend> _allFriends = [];

  ViewFriendsBloc(this.repository) : super(ViewFriendsInitial()) {
    on<LoadFriends>(_onLoadFriends);
    on<SearchFriends>(_onSearchFriends);
    on<StartChatWithFriend>(_onStartChatWithFriend);
  }

  Future<void> _onLoadFriends(
    LoadFriends event,
    Emitter<ViewFriendsState> emit,
  ) async {
    emit(ViewFriendsLoading());

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      _allFriends = await repository.getFriends(userId);

      emit(ViewFriendsLoaded(_allFriends));
    } catch (e) {
      emit(ViewFriendsError('Failed to load friends'));
    }
  }

  void _onSearchFriends(SearchFriends event, Emitter<ViewFriendsState> emit) {
    final query = event.query.toLowerCase();

    final filtered = _allFriends.where((friend) {
      return friend.name.toLowerCase().contains(query);
    }).toList();

    emit(ViewFriendsLoaded(filtered));
  }

  Future<void> _onStartChatWithFriend(
    StartChatWithFriend event,
    Emitter<ViewFriendsState> emit,
  ) async {
    try {
      final MyCircle chat = await repository
          .getOrCreateIndividualChatWithFriend(event.friendId);

      if (chat != null) {
        emit(ViewFriendsNavigateToChat(chat));

        // restore list state so UI doesn’t break
        emit(ViewFriendsLoaded(_allFriends));
      }
    } catch (e) {
      emit(ViewFriendsError('Failed to start chat'));
    }
  }

  Future<MyCircle> startChat(String friendId) async {
    return await repository.getOrCreateIndividualChatWithFriend(friendId);
  }
}
