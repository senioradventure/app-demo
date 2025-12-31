import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/enum/profile_visibility.dart';
import 'package:senior_circle/core/utils/phone_number_masker.dart';
import 'package:senior_circle/features/profile/bloc/profile_event.dart';
import 'package:senior_circle/features/profile/bloc/profile_state.dart';
import 'package:senior_circle/features/profile/models/profile_model.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdateVisibility>(_onUpdateVisibility);
  }

  void _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) {
 
    emit(
      ProfileLoaded(
        ProfileModel(
          name: 'Nidha',
          location: 'Kochi',
          imageUrl: '',
          visibility:ProfileVisibility.public,
          phone: maskPhoneNumber('+917894561230'), 
          friendsCount: 0,
        ),
      ),
    );
  }

  void _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final current = (state as ProfileLoaded).profile;

      emit(
        ProfileLoaded(
          current.copyWith(
            name: event.name,
            location: event.location,
            imageUrl: event.imageUrl,
          ),
        ),
      );
    }
  }

  void _onUpdateVisibility(
    UpdateVisibility event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      final current = (state as ProfileLoaded).profile;

      emit(
        ProfileLoaded(
          current.copyWith(visibility: event.visibility),
        ),
      );
    }
  }
}
