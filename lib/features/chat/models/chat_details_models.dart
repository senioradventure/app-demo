enum ChatType { room, circle }

enum ChatRole { admin, member, moderator }

class ChatDetailsModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String? adminId;
  final ChatType type;

  ChatDetailsModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.adminId,
    required this.type,
  });
}

class RoomDetails extends ChatDetailsModel {
  final String? description;

  RoomDetails({
    required super.id,
    required super.name,
    super.imageUrl,
    super.adminId,
    this.description,
  }) : super(type: ChatType.room);

  factory RoomDetails.fromJson(Map<String, dynamic> json) {
    return RoomDetails(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      adminId: json['admin_id'],
      description: json['description'],
    );
  }
}

class CircleDetails extends ChatDetailsModel {
  CircleDetails({
    required super.id,
    required super.name,
    super.imageUrl,
    super.adminId,
  }) : super(type: ChatType.circle);

  factory CircleDetails.fromJson(Map<String, dynamic> json) {
    return CircleDetails(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      adminId: json['admin_id'],
    );
  }
}

class ChatMember {
  final String userId;
  final String? name;
  final String? avatarUrl;
  final ChatRole role;

  // Helper to determine if admin
  bool get isAdmin => role == ChatRole.admin;

  ChatMember({
    required this.userId,
    this.name,
    this.avatarUrl,
    required this.role,
  });

  factory ChatMember.fromJson(
    Map<String, dynamic> json, {
    bool isCircle = false,
  }) {
    // For circles, the role is explicit in the join table
    // For rooms, we might need to infer or it might not be fully implemented in DB yet based on user description
    // But assuming the standard structure from `live_chat_participants` or `circle_members` joined with `profiles`

    final profile = json['profiles'] ?? {}; // Assuming join with profiles table

    ChatRole role = ChatRole.member;
    if (json['role'] == 'admin') {
      role = ChatRole.admin;
    }

    return ChatMember(
      userId: json['user_id'] ?? profile['id'],
      name: profile['full_name'] ?? profile['username'] ?? 'Unknown',
      avatarUrl: profile['avatar_url'],
      role: role,
    );
  }
}
