class MyCircle {
  final String id;
  final String name;
  final String? imageUrl;

  /// Group-only
  final String? adminId;
  final String? inviteCode;

  /// Individual chat only
  final String? otherUserId;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  bool get isGroup => adminId != null;
  bool get isIndividual => otherUserId != null;

  MyCircle({
    required this.id,
    required this.name,
    this.imageUrl,
    this.adminId,
    this.inviteCode,
    this.otherUserId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory MyCircle.fromSupabase(Map<String, dynamic> json) {
    return MyCircle(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      adminId: json['admin_id'],
      inviteCode: json['invite_code'],
      otherUserId: null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
    );
  }

  factory MyCircle.fromConversationRpc(Map<String, dynamic> json) {
    final otherUser = json['other_user'] as Map<String, dynamic>;

    final String? rawUpdated = json['updated_at'] ?? json['last_message_created_at'];

    return MyCircle(
      id: json['conversation_id'],
      name: otherUser['full_name'] ?? otherUser['username'] ?? 'Unknown',
      imageUrl: otherUser['avatar_url'],
      adminId: null,
      inviteCode: null,
      otherUserId: otherUser['id'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: rawUpdated != null ? DateTime.tryParse(rawUpdated) : null,
      deletedAt: null,
    );
  }
}
