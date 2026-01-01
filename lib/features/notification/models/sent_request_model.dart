enum RequestStatus { waiting, accepted, rejected }

class SentRequestModel {
  final String id;
  final String name;
  final String? imageUrl;
  final RequestStatus status;
  final String time;

  SentRequestModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.status,
    required this.time,
  });

  SentRequestModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    RequestStatus? status,
    String? time,
  }) {
    return SentRequestModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      status: status ?? this.status,
      time: time ?? this.time,
    );
  }
}

