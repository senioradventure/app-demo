part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthPhoneSubmitted extends AuthEvent {
  final String phoneNumber;

  const AuthPhoneSubmitted(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class AuthOtpSubmitted extends AuthEvent {
  final String otp;

  const AuthOtpSubmitted(this.otp);

  @override
  List<Object?> get props => [otp];
}

class PickProfileFromGalleryEvent extends AuthEvent {}

class AuthNameUpdated extends AuthEvent {
  final String name;

  const AuthNameUpdated(this.name);

  @override
  List<Object?> get props => [name];
}

class AuthLocationQueryChanged extends AuthEvent {
  final String query;
  const AuthLocationQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class AuthLocationSelected extends AuthEvent {
  final LocationModel location;
  const AuthLocationSelected(this.location);

  @override
  List<Object?> get props => [location];
}

class AuthLocationUpdated extends AuthEvent {
  final String locationId;
  const AuthLocationUpdated(this.locationId);
}

class AuthLocationRemoved extends AuthEvent {}

class SubmitCreateUserEvent extends AuthEvent {}
