import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/constants/friends_list.dart';
import 'package:senior_circle/core/utils/phone_number_masker.dart';
import 'package:senior_circle/features/profile/bloc/profile_event.dart';
import 'package:senior_circle/features/profile/bloc/profile_state.dart';
import 'package:senior_circle/core/enum/profile_visibility.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfileVisibility>(_onUpdateVisibility);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    await Future.delayed(const Duration(milliseconds: 400));

    emit(
      ProfileLoaded(
        name: 'Name',
        phone: maskPhoneNumber('+91 9876543210'),
        friendsCount: friends.length,
        visibility: ProfileVisibility.private,
      ),
    );
  }
  

  void _onUpdateVisibility(
    UpdateProfileVisibility event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      emit(
        (state as ProfileLoaded).copyWith(
          visibility: event.visibility,
        ),
      );
    }
  }
}
