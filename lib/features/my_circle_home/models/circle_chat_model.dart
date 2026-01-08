class CircleChat {
  final String id;
  final String name;
  final String? imageUrl;

  /// Group-only
  final String? adminId;
  final String? inviteCode;

  /// Individual chat only
  final String? otherUserId;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  bool get isGroup => adminId != null;
  bool get isIndividual => otherUserId != null;

  CircleChat({
    required this.id,
    required this.name,
    this.imageUrl,
    this.adminId,
    this.inviteCode,
    this.otherUserId,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory CircleChat.fromSupabase(Map<String, dynamic> json) {
    return CircleChat(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      adminId: json['admin_id'],
      inviteCode: json['invite_code'],
      otherUserId: null,
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
      id: json['conversation_id'],
      name: otherUser['full_name'] ?? otherUser['username'] ?? 'Unknown',
      imageUrl: otherUser['avatar_url'],
      adminId: null,
      inviteCode: null,
      otherUserId: otherUser['id'], // ✅ FIX HERE
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: null,
    );
  }
}
