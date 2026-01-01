import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/utils/image_compressor.dart';
import 'package:senior_circle/core/utils/location_service/location_model.dart';
import 'package:senior_circle/core/utils/location_service/location_service.dart';
import 'package:senior_circle/features/auth/model/auth_model.dart';
import 'package:senior_circle/features/auth/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ImagePicker _picker = ImagePicker();
  final AuthRepository _authRepository;
  final LocationService locationService;
  List<LocationModel> allLocations = [];

  String? _phoneNumber;

  AuthBloc(this._authRepository, this.locationService) : super(AuthInitial()) {
    on<AuthPhoneSubmitted>(_onPhoneSubmitted);
    on<AuthOtpSubmitted>(_onOtpSubmitted);
    on<PickProfileFromGalleryEvent>(_pickProfileImage);
    on<AuthNameUpdated>(_onNameUpdated);
    on<AuthLocationQueryChanged>(_onLocationQueryChanged);
    on<AuthLocationSelected>(_onLocationSelected);
    on<AuthLocationRemoved>(_onLocationRemoved);
    on<SubmitCreateUserEvent>(_onSubmitCreateUser);
    on<AuthLocationUpdated>((event, emit) {
      if (state is! CreateUserState) return;

      final current = state as CreateUserState;

      emit(
        current.copyWith(
          authModel: current.authModel.copyWith(locationId: event.locationId),
        ),
      );
    });
  }

  Future<void> _onPhoneSubmitted(
    AuthPhoneSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await _authRepository.sendOtp(event.phoneNumber);
      _phoneNumber = event.phoneNumber;
      emit(OtpSent(event.phoneNumber));
    } catch (_) {
      emit(const AuthError("Failed to send OTP"));
    }
  }

  Future<void> _onOtpSubmitted(
    AuthOtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    if (_phoneNumber == null) {
      emit(const AuthError("Phone number missing"));
      return;
    }

    emit(AuthLoading());

    try {
      final response = await _authRepository.verifyOtp(
        phoneNumber: _phoneNumber!,
        otp: event.otp,
      );

      final user = response.user;

      if (response.session == null || user == null) {
        emit(const AuthError("Invalid OTP"));
        return;
      }

      /// 🔹 CHECK IF PROFILE EXISTS
      final bool profileExists = await _authRepository.doesUserProfileExist(
        user.id,
      );

      /// 🔹 EXISTING USER → DASHBOARD
      if (profileExists) {
        emit(AuthExistingUser());
        return;
      }

      /// 🔹 NEW USER → CREATE PROFILE FLOW
      allLocations = await locationService.fetchLocations();

      emit(
        CreateUserState(
          authModel: AuthModel(
            phoneNumber: _phoneNumber!,
            uid: user.id,
            profileFile: File(''),
            name: '',
            locationId: '',
          ),
          filteredLocation: allLocations,
        ),
      );
    } catch (_) {
      emit(const AuthError("OTP verification failed"));
    }
  }

  String? get phoneNumber => _phoneNumber;

  Future<void> _pickProfileImage(
    PickProfileFromGalleryEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! CreateUserState) return;

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

    emit(
      (state as CreateUserState).copyWith(
        profileFile: compressedFile ?? originalFile,
      ),
    );
  }

  void _onNameUpdated(AuthNameUpdated event, Emitter<AuthState> emit) {
    if (state is! CreateUserState) return;

    final currentState = state as CreateUserState;

    emit(
      currentState.copyWith(
        authModel: currentState.authModel.copyWith(name: event.name),
      ),
    );
  }

  void _onLocationQueryChanged(
    AuthLocationQueryChanged event,
    Emitter<AuthState> emit,
  ) {
    if (state is! CreateUserState) return;

    final currentState = state as CreateUserState;
    final query = event.query.toLowerCase();

    final filtered = allLocations
        .where(
          (loc) =>
              loc.name.toLowerCase().contains(query) &&
              currentState.selectedLocation?.id != loc.id,
        )
        .toList();

    emit(
      currentState.copyWith(
        locationQuery: event.query,
        filteredLocation: filtered,
        showLocationDropdown: filtered.isNotEmpty && query.isNotEmpty,
      ),
    );
  }

  void _onLocationSelected(
    AuthLocationSelected event,
    Emitter<AuthState> emit,
  ) {
    if (state is! CreateUserState) return;

    final currentState = state as CreateUserState;

    emit(
      currentState.copyWith(
        selectedLocation: event.location,
        filteredLocation: [],
        showLocationDropdown: false,
        locationQuery: '',
        authModel: currentState.authModel.copyWith(
          locationId: event.location.id,
        ),
      ),
    );
  }

  void _onLocationRemoved(AuthLocationRemoved event, Emitter<AuthState> emit) {
    if (state is! CreateUserState) return;

    final currentState = state as CreateUserState;

    emit(
      currentState.copyWith(
        selectedLocation: null,
        locationQuery: '',
        showLocationDropdown: false,
        authModel: currentState.authModel.copyWith(locationId: ''),
      ),
    );
  }

  Future<void> _onSubmitCreateUser(
    SubmitCreateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! CreateUserState) return;

    final current = state as CreateUserState;
    final model = current.authModel;

    if (model.name.isEmpty || model.locationId.isEmpty) {
      emit(const AuthError("Name and location are required"));
      return;
    }

    emit(current.copyWith(isSubmitting: true));

    try {
      String? avatarUrl;

      /// 🔹 Upload image
      if (model.profileFile.path.isNotEmpty) {
        avatarUrl = await _authRepository.uploadProfileImage(
          file: model.profileFile,
          userId: model.uid,
        );
      }

      /// 🔹 Insert profile
      await _authRepository.createProfile(
        userId: model.uid,
        phoneNumber: model.phoneNumber, // ✅ added
        fullName: model.name,
        avatarUrl: avatarUrl,
        locationId: model.locationId,
      );

      emit(current.copyWith(isSubmitting: false));

      await Future.microtask(() {
        emit(CreateUserSuccess());
      });
    } on PostgrestException catch (e) {
      print(e.message);
      emit(AuthError(e.message));
    } on StorageException catch (e) {
      print(e.message);
      emit(AuthError(e.message));
    } catch (e) {
      print(e);
      emit(AuthError(e.toString()));
    }
  }
}
