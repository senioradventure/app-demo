class Contact {
  final String id;
  final String name;  
  final String? image_url;
  final String? description;
  final String? admin_id;
  final String? location_id;
  final List<String> interests;
  final bool is_active;

  Contact({
    required this.id,
    required this.name,
    required this.admin_id,
    required this.location_id,
    required this.interests,
    this.image_url,
    this.description,
    this.is_active = true,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unnamed Room',
      image_url: json['image_url'],
      description: json['description'],
      admin_id: json['admin_id'],
      location_id: json['location_id'],
      interests: List<String>.from(json['interests'] ?? []),
      is_active: json['is_active'] ?? true,
    );
  }
}
