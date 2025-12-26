class PreviewDetailsModel {
  final String imageUrl;
  final String name;
  final List<String> interests;
  final String description;

  PreviewDetailsModel({
    required this.imageUrl,
    required this.name,
    required this.interests,
    required this.description,
  });

  /// Convert JSON → Model
  factory PreviewDetailsModel.fromJson(Map<String, dynamic> json) {
    return PreviewDetailsModel(
      imageUrl: json['imageUrl'] as String,
      name: json['name'] as String,
      interests: List<String>.from(json['interests'] ?? []),
      description: json['description'] as String? ?? '',
    );
  }

  /// Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'name': name,
      'interests': interests,
      'description': description,
    };
  }
}