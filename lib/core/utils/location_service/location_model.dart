class LocationModel {
  final String id;
  final String name;

  const LocationModel({required this.id, required this.name});

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(id: map['id'] as String, name: map['name'] as String);
  }
}
