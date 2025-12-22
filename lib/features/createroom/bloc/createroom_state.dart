part of 'createroom_bloc.dart';

@immutable
class CreateroomState {
  final File? imageFile;
  final int nameCount;
  final int descriptionCount;

  // Interests
  final List<String> selected;
  final List<String> filtered;
  final bool showDropdown;
  final String query;

  // Locations (UPDATED)
  final LocationModel? selectedLocation;
  final List<LocationModel> filteredLocation;
  final bool showLocationDropdown;
  final String locationQuery;

  final CreateroomStatus status;

  const CreateroomState({
    this.imageFile,
    this.nameCount = 0,
    this.descriptionCount = 0,
    this.selected = const [],
    this.filtered = const [],
    this.showDropdown = false,
    this.query = '',
    this.selectedLocation,
    this.filteredLocation = const [],
    this.showLocationDropdown = false,
    this.locationQuery = '',
    this.status = const CreateroomInitial(),
  });

  CreateroomState copyWith({
    File? imageFile,
    int? nameCount,
    int? descriptionCount,
    List<String>? selected,
    List<String>? filtered,
    bool? showDropdown,
    String? query,
    LocationModel? selectedLocation,
    List<LocationModel>? filteredLocation,
    bool? showLocationDropdown,
    String? locationQuery,
    CreateroomStatus? status,
  }) {
    return CreateroomState(
      imageFile: imageFile ?? this.imageFile,
      nameCount: nameCount ?? this.nameCount,
      descriptionCount: descriptionCount ?? this.descriptionCount,
      selected: selected ?? this.selected,
      filtered: filtered ?? this.filtered,
      showDropdown: showDropdown ?? this.showDropdown,
      query: query ?? this.query,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      filteredLocation: filteredLocation ?? this.filteredLocation,
      showLocationDropdown: showLocationDropdown ?? this.showLocationDropdown,
      locationQuery: locationQuery ?? this.locationQuery,
      status: status ?? this.status,
    );
  }
}

/// STATUS CLASSES
@immutable
sealed class CreateroomStatus {
  const CreateroomStatus();
}

class CreateroomInitial extends CreateroomStatus {
  const CreateroomInitial();
}

class CreateroomValidationError extends CreateroomStatus {
  final String message;
  const CreateroomValidationError(this.message);
}

class CreateroomPreviewReady extends CreateroomStatus {
  final CreateroomPreviewDetailsModel preview;
  const CreateroomPreviewReady(this.preview);
}
