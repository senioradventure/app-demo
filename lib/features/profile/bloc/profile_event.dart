import 'package:senior_circle/core/enum/profile_visibility.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String name;
  final String location;
  final String imageUrl;

  UpdateProfile({
    required this.name,
    required this.location,
    required this.imageUrl,
  });
}

class UpdateVisibility extends ProfileEvent {
  final ProfileVisibility visibility;

  UpdateVisibility(this.visibility);
}

