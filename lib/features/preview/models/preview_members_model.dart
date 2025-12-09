class MemberModel {
  final String url;
  final String name;
  final bool isAdmin;

  MemberModel({required this.url, required this.name, required this.isAdmin});

  /// JSON → Model
  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      url: json['url'] as String,
      name: json['name'] as String,
      isAdmin: (json['admin'] ?? 0) == 1,
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {'url': url, 'name': name, 'admin': isAdmin ? 1 : 0};
  }
}
