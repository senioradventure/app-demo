import 'package:senior_circle/core/enum/profile_visibility.dart';

class ProfileModel {
  final String name;
  final String phone;
  final int friendsCount;
  final ProfileVisibility visibility;
  final String imageUrl;
  final String location;

  const ProfileModel({
    required this.name,
    required this.phone,
    required this.friendsCount,
    required this.visibility,
    required this.imageUrl,
    required this.location,
  });

  ProfileModel copyWith({
    String? name,
     ProfileVisibility? visibility,
    String? imageUrl,
    String? location,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      phone: phone,
      friendsCount: friendsCount,
      visibility: visibility ?? this.visibility,
      imageUrl: imageUrl ?? this.imageUrl,
      location: location ?? this.location,
    );
  }
}
