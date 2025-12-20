import 'package:uuid/uuid.dart';

class CircleChat {
  static const _uuid = Uuid();
  final String id;
  final String name;
  final String? lastMessage;
  final String? imageUrl;
  final String? adminId;
  final DateTime? time;
  final int unreadCount;

  CircleChat({
    String? id,
    required this.name,
    this.lastMessage,
    this.imageUrl,
    this.adminId,
    this.time,
    this.unreadCount = 0,
  }) : id = id ?? _uuid.v4();


  bool get isGroup => adminId != null;

  CircleChat copyWith({
    String? id,
    String? name,
    String? lastMessage,
    String? imageUrl,
    String? adminId,
    DateTime? time,
    int? unreadCount,
  }) {
    return CircleChat(
      id: id ?? this.id,
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      imageUrl: imageUrl ?? this.imageUrl,
      adminId: adminId ?? this.adminId,
      time: time ?? this.time,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  factory CircleChat.fromJson(Map<String, dynamic> json) {
    return CircleChat(
      id: json['id'] as String?,
      name: json['name'] as String,
      lastMessage: json['last_message'] as String?,
      imageUrl: json['image_url'] as String?,
      adminId: json['admin_id'] as String?,
      time: DateTime.parse(json['time']),
      unreadCount: json['unread_count'] as int? ?? 0,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'last_message': lastMessage,
      'image_url': imageUrl,
      'admin_id': adminId,
      'time': time!.toIso8601String(),
      'unread_count': unreadCount,
    };
  }
}
