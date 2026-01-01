part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthExistingUser extends AuthState {}

class AuthNewUser extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSent extends AuthState {
  final String phoneNumber;

  const OtpSent(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class Authenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class CreateUserState extends AuthState {
  final AuthModel authModel;

  final String locationQuery;
  final List<LocationModel> filteredLocation;
  final LocationModel? selectedLocation;
  final bool showLocationDropdown;

  final bool isSubmitting; // ✅ NEW

  const CreateUserState({
    required this.authModel,
    this.locationQuery = '',
    this.filteredLocation = const [],
    this.selectedLocation,
    this.showLocationDropdown = false,
    this.isSubmitting = false, // ✅ default
  });

  @override
  List<Object?> get props => [
    authModel,
    locationQuery,
    filteredLocation,
    selectedLocation,
    showLocationDropdown,
    isSubmitting,
  ];

  CreateUserState copyWith({
    AuthModel? authModel,
    File? profileFile,
    String? locationQuery,
    List<LocationModel>? filteredLocation,
    LocationModel? selectedLocation,
    bool? showLocationDropdown,
    bool? isSubmitting,
  }) {
    return CreateUserState(
      authModel:
          authModel ??
          this.authModel.copyWith(
            profileFile: profileFile ?? this.authModel.profileFile,
          ),
      locationQuery: locationQuery ?? this.locationQuery,
      filteredLocation: filteredLocation ?? this.filteredLocation,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      showLocationDropdown: showLocationDropdown ?? this.showLocationDropdown,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class CreateUserLoading extends AuthState {}

class CreateUserSuccess extends AuthState {
  @override
  List<Object?> get props => [];
}
