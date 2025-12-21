import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/constants/strings/lists.dart';
import 'package:senior_circle/core/utils/image_compressor.dart';
import 'package:senior_circle/core/utils/location_service/location_model.dart';
import 'package:senior_circle/core/utils/location_service/location_service.dart';
import 'package:senior_circle/features/createroom/models/createroom_preview_details_model.dart';

part 'createroom_event.dart';
part 'createroom_state.dart';

class CreateroomBloc extends Bloc<CreateroomEvent, CreateroomState> {
  final ImagePicker _picker = ImagePicker();
  final LocationService locationService;

  // Static interests
  final List<String> allInterests = AppLists.interests;

  // Dynamic locations (from Supabase)
  List<LocationModel> allLocations = [];

  CreateroomBloc({required this.locationService})
    : super(const CreateroomState()) {
    // ---------- RESET ----------
    on<ResetCreateRoomEvent>((event, emit) {
      emit(const CreateroomState());
    });

    // ---------- LOAD LOCATIONS ----------
    on<LoadLocationsEvent>((event, emit) async {
      try {
        final locations = await locationService.fetchLocations();

        allLocations = locations;

        emit(
          state.copyWith(
            filteredLocation: locations,
            showLocationDropdown: false,
          ),
        );
      } catch (e) {
        debugPrint('Failed to load locations: $e');
      }
    });

    // ---------- IMAGE PICK ----------
    on<PickImageFromGalleryEvent>((event, emit) async {
      final XFile? pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (pickedImage == null) return;

      final originalFile = File(pickedImage.path);
      final compressedFile = await ImageCompressor.compressImage(
        imageFile: originalFile,
        quality: 65,
        minWidth: 1080,
        minHeight: 1080,
      );

      emit(state.copyWith(imageFile: compressedFile ?? originalFile));
    });

    // ---------- TEXT COUNTERS ----------
    on<NameTextFieldCounterEvent>((event, emit) {
      emit(state.copyWith(nameCount: event.count));
    });

    on<DisDescriptionTextFieldCounterEvent>((event, emit) {
      emit(state.copyWith(descriptionCount: event.count));
    });

    // ---------- INTEREST SEARCH ----------
    on<SearchInterestEvent>((event, emit) {
      final query = event.query.toLowerCase();

      final filtered = allInterests
          .where(
            (item) =>
                item.toLowerCase().contains(query) &&
                !state.selected.contains(item),
          )
          .toList();

      emit(
        state.copyWith(
          query: event.query,
          filtered: filtered,
          showDropdown: filtered.isNotEmpty && query.isNotEmpty,
        ),
      );
    });

    // ---------- ADD INTEREST ----------
    on<AddInterestEvent>((event, emit) {
      if (state.selected.length >= 3) return;

      final updated = List<String>.from(state.selected)..add(event.interest);

      emit(
        state.copyWith(
          selected: updated,
          filtered: [],
          showDropdown: false,
          query: '',
        ),
      );
    });

    // ---------- REMOVE INTEREST ----------
    on<RemoveInterestEvent>((event, emit) {
      final updated = List<String>.from(state.selected)..remove(event.interest);

      emit(state.copyWith(selected: updated));
    });

    // ---------- LOCATION SEARCH ----------
    on<SearchLocationEvent>((event, emit) {
      final query = event.query.toLowerCase();

      final filtered = allLocations
          .where(
            (loc) =>
                loc.name.toLowerCase().contains(query) &&
                state.selectedLocation?.id != loc.id,
          )
          .toList();

      emit(
        state.copyWith(
          locationQuery: event.query,
          filteredLocation: filtered,
          showLocationDropdown: filtered.isNotEmpty && query.isNotEmpty,
        ),
      );
    });

    // ---------- ADD LOCATION ----------
    on<AddLocationEvent>((event, emit) {
      emit(
        state.copyWith(
          selectedLocation: event.location,
          filteredLocation: [],
          showLocationDropdown: false,
          locationQuery: '',
        ),
      );
    });

    // ---------- REMOVE LOCATION ----------
    on<RemoveLocationEvent>((event, emit) {
      emit(state.copyWith(selectedLocation: null));
    });

    // ---------- CONFIRM ----------
    on<ConfirmCreateRoomEvent>((event, emit) {
      if (state.imageFile == null) {
        emit(
          state.copyWith(
            status: const CreateroomValidationError("Please select an image"),
          ),
        );
        return;
      }

      if (event.roomName.trim().isEmpty) {
        emit(
          state.copyWith(
            status: const CreateroomValidationError("Room name is required"),
          ),
        );
        return;
      }

      if (state.selectedLocation == null) {
        emit(
          state.copyWith(
            status: const CreateroomValidationError("Please select a location"),
          ),
        );
        return;
      }

      if (state.selected.isEmpty) {
        emit(
          state.copyWith(
            status: const CreateroomValidationError(
              "Select at least one interest",
            ),
          ),
        );
        return;
      }

      final preview = CreateroomPreviewDetailsModel(
        imageFile: state.imageFile!,
        name: event.roomName.trim(),
        interests: state.selected,
        description: event.description.trim(),
        locationId: state.selectedLocation!.id,
        locationName: state.selectedLocation!.name,
      );

      emit(state.copyWith(status: CreateroomPreviewReady(preview)));
    });
  }
}
