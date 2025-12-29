import 'package:senior_circle/core/enum/profile_visibility.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfileVisibility extends ProfileEvent {
  final ProfileVisibility visibility;

  UpdateProfileVisibility(this.visibility);
}
