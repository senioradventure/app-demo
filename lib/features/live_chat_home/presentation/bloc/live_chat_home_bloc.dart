import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:senior_circle/features/live_chat_home/presentation/repository/live_chat_home_repo.dart';
import 'package:senior_circle/core/constants/contact.dart';

part 'live_chat_home_event.dart';
part 'live_chat_home_state.dart';

class LiveChatHomeBloc extends Bloc<LiveChatHomeEvent, LiveChatHomeState> {
  final LiveChatHomeRepository repo;

  LiveChatHomeBloc(this.repo) : super(const LiveChatHomeState()) {
    on<FetchLocationsEvent>(_onFetchLocations);
    on<FetchRoomsEvent>(_onFetchRooms);
    on<UpdateLocationFilterEvent>(_onUpdateLocation);
    on<UpdateInterestFilterEvent>(_onUpdateInterest);
    on<UpdateSearchEvent>(_onUpdateSearch);
  }

  Future<void> _onFetchLocations(
    FetchLocationsEvent event,
    Emitter<LiveChatHomeState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final locations = await repo.fetchLocations();

    emit(state.copyWith(locations: locations, loading: false));
  }

  Future<void> _onFetchRooms(
    FetchRoomsEvent event,
    Emitter<LiveChatHomeState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final rooms = await repo.fetchRooms();

    emit(state.copyWith(rooms: rooms));

    final filtered = _applyFilters(
      rooms,
      state.selectedLocation,
      state.selectedInterest,
      state.search,
    );

    emit(state.copyWith(filteredRooms: filtered, loading: false));
  }

  void _onUpdateLocation(
    UpdateLocationFilterEvent event,
    Emitter<LiveChatHomeState> emit,
  ) {
    final filtered = _applyFilters(
      state.rooms,
      event.location,
      state.selectedInterest,
      state.search,
    );

    emit(
      state.copyWith(
        selectedLocation: event.location,
        clearLocation: event.location == null,
        filteredRooms: filtered,
      ),
    );
  }

  void _onUpdateInterest(
    UpdateInterestFilterEvent event,
    Emitter<LiveChatHomeState> emit,
  ) {
    final filtered = _applyFilters(
      state.rooms,
      state.selectedLocation,
      event.interest,
      state.search,
    );

    emit(
      state.copyWith(
        selectedInterest: event.interest,
        clearInterest: event.interest == null,
        filteredRooms: filtered,
      ),
    );
  }

  void _onUpdateSearch(
    UpdateSearchEvent event,
    Emitter<LiveChatHomeState> emit,
  ) {
    final search = event.search.toLowerCase();

    final filtered = _applyFilters(
      state.rooms,
      state.selectedLocation,
      state.selectedInterest,
      search,
    );

    emit(state.copyWith(search: search, filteredRooms: filtered));
  }

  List<Contact> _applyFilters(
    List<Contact> rooms,
    String? location,
    String? interest,
    String search,
  ) {
    return rooms.where((room) {
      final matchesSearch =
          search.isEmpty || room.name.toLowerCase().contains(search);

      final matchesLocation =
          location == null || location.isEmpty || room.location_id == location;

      final matchesInterest =
          interest == null ||
          interest.isEmpty ||
          room.interests.contains(interest);

      return matchesSearch && matchesLocation && matchesInterest;
    }).toList();
  }
}
