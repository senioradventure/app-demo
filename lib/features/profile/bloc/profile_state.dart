import 'package:senior_circle/core/enum/profile_visibility.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String name;
  final String phone;
  final int friendsCount;
  final ProfileVisibility visibility;

  ProfileLoaded({
    required this.name,
    required this.phone,
    required this.friendsCount,
    required this.visibility,
  });

  ProfileLoaded copyWith({
    ProfileVisibility? visibility,
  }) {
    return ProfileLoaded(
      name: name,
      phone: phone,
      friendsCount: friendsCount,
      visibility: visibility ?? this.visibility,
    );
  }
}
class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}