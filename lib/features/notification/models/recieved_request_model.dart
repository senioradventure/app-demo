class ReceivedRequestModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? text;
  final String time;

  const ReceivedRequestModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.text,
    required this.time,
  });

  ReceivedRequestModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? text,
    String? time,
  }) {
    return ReceivedRequestModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      text: text ?? this.text,
      time: time ?? this.time,
    );
  }
}
