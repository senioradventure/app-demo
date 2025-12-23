import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:senior_circle/core/constants/contact.dart';

part 'live_chat_home_event.dart';
part 'live_chat_home_state.dart';

class LiveChatHomeBloc extends Bloc<LiveChatHomeEvent, LiveChatHomeState> {
  LiveChatHomeBloc() : super(const LiveChatHomeState()) {
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

    final supabase = Supabase.instance.client;
    final response = await supabase.from('locations').select('name');

    final locations = response
        .map<String>((row) => row['name'] as String)
        .toSet()
        .toList();

    emit(state.copyWith(locations: locations, loading: false));
  }

  Future<void> _onFetchRooms(
    FetchRoomsEvent event,
    Emitter<LiveChatHomeState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final supabase = Supabase.instance.client;
    final response = await supabase.from('live_chat_rooms').select();

    final rooms = response
        .map<Contact>((json) => Contact.fromJson(json))
        .toList();

    final filtered = _applyFilters(
      rooms,
      state.selectedLocation,
      state.selectedInterest,
      state.search,
    );

    emit(state.copyWith(rooms: rooms, filteredRooms: filtered, loading: false));
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
      state.copyWith(selectedLocation: event.location, filteredRooms: filtered),
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
      state.copyWith(selectedInterest: event.interest, filteredRooms: filtered),
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
    List<Contact> result = List.from(rooms);

    if (location != null && location.isNotEmpty) {
      result = result
          .where(
            (room) =>
                room.location_id != null &&
                room.location_id!.toLowerCase() == location.toLowerCase(),
          )
          .toList();
    }

    if (interest != null && interest.isNotEmpty) {
      result = result
          .where((room) => room.interests.contains(interest))
          .toList();
    }

    if (search.isNotEmpty) {
      result = result
          .where((room) => room.name.toLowerCase().contains(search))
          .toList();
    }

    return result;
  }
}
