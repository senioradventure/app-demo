import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/utils/location_service/location_model.dart';
import 'package:senior_circle/features/profile/models/profile_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Profile profile;
  final XFile? profileImageFile;
  final List<LocationModel> allLocations;  
  final LocationModel? selectedLocation; 

  ProfileLoaded(
    this.profile, {
    this.profileImageFile,
    this.allLocations = const[],
    this.selectedLocation,
  });

  ProfileLoaded copyWith({
    Profile? profile,
    XFile? profileImageFile,
    List<LocationModel>? allLocations,
    LocationModel? selectedLocation,
  }) {
    return ProfileLoaded(
      profile ?? this.profile,
      profileImageFile: profileImageFile ?? this.profileImageFile,
      allLocations: allLocations ?? this.allLocations,
      selectedLocation: selectedLocation ?? this.selectedLocation,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}


