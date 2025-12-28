import 'dart:io';

class AuthModel {
  final String phoneNumber;
  final String uid;
  final File profileFile;
  final String name;
  final String locationId;

  AuthModel({
    required this.phoneNumber,
    required this.uid,
    required this.profileFile,
    required this.name,
    required this.locationId,
  });

  AuthModel copyWith({
    String? phoneNumber,
    String? uid,
    File? profileFile,
    String? name,
    String? locationId,
  }) {
    return AuthModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      uid: uid ?? this.uid,
      profileFile: profileFile ?? this.profileFile,
      name: name ?? this.name,
      locationId: locationId ?? this.locationId,
    );
  }
}
