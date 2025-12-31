import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/utils/location_service/location_model.dart';
import 'package:senior_circle/core/utils/location_service/location_service.dart';
import 'package:senior_circle/features/profile/bloc/profile_event.dart';
import 'package:senior_circle/features/profile/bloc/profile_state.dart';
import 'package:senior_circle/features/profile/repository/profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;
  final LocationService locationService;

  ProfileBloc(this.repository, this.locationService) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<PickProfileImage>(_onPickProfileImage);
    on<SubmitProfile>(_onSubmitProfile);
    on<ProfileLocationSelected>(_onProfileLocationSelected);
    on<UpdateProfileVisibility>(_onUpdateVisibility);
  }

  Future<void> _onProfileLocationSelected(
    ProfileLocationSelected event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) return;

    final current = state as ProfileLoaded;

    emit(
      current.copyWith(
        selectedLocation: event.location,
        profile: current.profile.copyWith(locationId: event.location?.id),
      ),
    );
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      final session = Supabase.instance.client.auth.currentSession;

      if (session == null) {
        emit(ProfileError('User not logged in'));
        return;
      }

      final userId = session.user.id;
      final profile = await repository.fetchProfile(userId);
      final locations = await locationService.fetchLocations();

      if (locations.isEmpty) {
        emit(ProfileError('Locations not available'));
        return;
      }

      LocationModel? selected;

      if (profile.locationId != null) {
        selected = locations
            .where((l) => l.id == profile.locationId)
            .cast<LocationModel?>()
            .firstOrNull;
      }

      emit(
        ProfileLoaded(
          profile,
          allLocations: locations,
          selectedLocation: selected,
          profileImageFile: null,
        ),
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) return;

    final current = state as ProfileLoaded;

    emit(
      current.copyWith(
        profile: current.profile.copyWith(
          fullName: event.fullName ?? current.profile.fullName,
          locationId: event.locationId ?? current.profile.locationId,
          avatarUrl: event.avatarUrl ?? current.profile.avatarUrl,
        ),
      ),
    );
  }

  Future<void> _onPickProfileImage(
    PickProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) return;

    final current = state as ProfileLoaded;

    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      emit(current.copyWith(profileImageFile: image));
    }
  }

  Future<void> _onSubmitProfile(
    SubmitProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is! ProfileLoaded) return;

    final current = state as ProfileLoaded;
    emit(ProfileLoading());

    try {
      final updatedProfile = await repository.updateProfile(
        userId: current.profile.id,
        fullName: current.profile.fullName,
        locationId: current.profile.locationId,
        imageFile: current.profileImageFile,
      );

      emit(
        ProfileLoaded(
          updatedProfile,
          allLocations: current.allLocations,
          selectedLocation: current.selectedLocation,
          profileImageFile: null,
        ),
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateVisibility(
    UpdateProfileVisibility event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;

    if (currentState is! ProfileLoaded) return;

    final updatedProfile = currentState.profile.copyWith(
      settings: currentState.profile.settings!.copyWith(
        visibility: event.visibility,
      ),
    );

    emit(ProfileLoaded(updatedProfile));

    try {
      await repository.updateVisibility(
        userId: currentState.profile.id,
        visibility: event.visibility,
      );
    } catch (e) {
      emit(currentState);
    }
  }
}
