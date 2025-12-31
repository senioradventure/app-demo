import 'package:senior_circle/core/enum/profile_visibility.dart';
import 'package:senior_circle/core/utils/location_service/location_model.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class PickProfileImage extends ProfileEvent {}


class UpdateProfile extends ProfileEvent {
  final String? fullName;
  final String? avatarUrl;
  final String? locationId;

  UpdateProfile({
    this.fullName,
    this.avatarUrl,
    this.locationId,
  });
}

class SubmitProfile extends ProfileEvent {}

class ProfileLocationSelected extends ProfileEvent {
  final LocationModel? location;
  ProfileLocationSelected(this.location);
}


class UpdateProfileVisibility extends ProfileEvent {
  final ProfileVisibility visibility;

  UpdateProfileVisibility(this.visibility);
}

