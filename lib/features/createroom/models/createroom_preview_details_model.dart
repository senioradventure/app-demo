import 'dart:io';

class CreateroomPreviewDetailsModel {
  final File imageFile;
  final String name;
  final List<String> interests;
  final String description;

  CreateroomPreviewDetailsModel({
    required this.imageFile,
    required this.name,
    required this.interests,
    required this.description,
  });

  /// Convert JSON → Model (LOCAL PREVIEW ONLY)
  factory CreateroomPreviewDetailsModel.fromJson(Map<String, dynamic> json) {
    return CreateroomPreviewDetailsModel(
      imageFile: File(json['imagePath']),
      name: json['name'] as String,
      interests: List<String>.from(json['interests'] ?? []),
      description: json['description'] as String? ?? '',
    );
  }

  /// Convert Model → JSON
  /// (Used ONLY for navigation / temporary storage)
  Map<String, dynamic> toJson() {
    return {
      'imagePath': imageFile.path,
      'name': name,
      'interests': interests,
      'description': description,
    };
  }
}
