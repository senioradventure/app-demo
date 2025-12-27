part of 'live_chat_home_bloc.dart';

class LiveChatHomeState extends Equatable {
  final List<Map<String, String>> locations; 

  final List<String> interests;
  final List<Contact> rooms;
  final List<Contact> filteredRooms;

  final String? selectedLocation;
  final String? selectedInterest;
  final String search;

  final bool loading;

  const LiveChatHomeState({
    this.locations = const <Map<String, String>>[], 
    this.interests = const [],
    this.rooms = const [],
    this.filteredRooms = const [],
    this.selectedLocation,
    this.selectedInterest,
    this.search = "",
    this.loading = false,
  });

  LiveChatHomeState copyWith({
    List<Map<String, String>>? locations,
    List<String>? interests,
    List<Contact>? rooms,
    List<Contact>? filteredRooms,

    bool clearLocation = false,
    bool clearInterest = false,

    String? selectedLocation,
    String? selectedInterest,
    String? search,
    bool? loading,
  }) {
    return LiveChatHomeState(
      locations: locations ?? this.locations,

      interests: interests ?? this.interests,
      rooms: rooms ?? this.rooms,
      filteredRooms: filteredRooms ?? this.filteredRooms,

      selectedLocation:
          clearLocation ? null : selectedLocation ?? this.selectedLocation,

      selectedInterest:
          clearInterest ? null : selectedInterest ?? this.selectedInterest,

      search: search ?? this.search,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object?> get props => [
        locations,
        interests,
        rooms,
        filteredRooms,
        selectedLocation,
        selectedInterest,
        search,
        loading,
      ];
}
