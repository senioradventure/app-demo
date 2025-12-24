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

    final response = await supabase.from('locations').select('id, name');

    final locations = response.map<Map<String, String>>((row) {
      return {"id": row['id'] as String, "name": row['name'] as String};
    }).toList();

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
