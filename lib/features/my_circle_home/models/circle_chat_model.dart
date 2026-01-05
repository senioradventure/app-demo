class CircleChat {
  final String id;
  final String name;
  final String? imageUrl;
  final String? adminId;
  final String? inviteCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  bool get isGroup => adminId != null;

  CircleChat({
    required this.id,
    required this.name,
    this.imageUrl,
    this.adminId,
    this.inviteCode,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory CircleChat.fromSupabase(Map<String, dynamic> json) {
    return CircleChat(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?,
      adminId: json['admin_id'] as String?,
      inviteCode: json['invite_code'] as String?,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  factory CircleChat.fromConversationRpc(Map<String, dynamic> json) {
    final otherUser = json['other_user'] as Map<String, dynamic>;

    return CircleChat(
      id: json['conversation_id'] as String,
      name: otherUser['full_name'] ?? otherUser['username'] ?? 'Unknown',
      imageUrl: otherUser['avatar_url'] as String?,
      adminId: null, // individual chat
      inviteCode: null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: null,
    );
  }
}
