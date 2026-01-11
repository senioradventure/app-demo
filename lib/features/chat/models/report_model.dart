class ReportModel {
  final String id;
  final String reporterId;
  final String reportedUserId;
  final String reportedMessageId;
  final String reason;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Additional fields from JOIN queries
  final String? reportedUserName;
  final String? reportedUserAvatar;
  final String? messageContent;
  final int reportCount;

  ReportModel({
    required this.id,
    required this.reporterId,
    required this.reportedUserId,
    required this.reportedMessageId,
    required this.reason,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.reportedUserName,
    this.reportedUserAvatar,
    this.messageContent,
    this.reportCount = 1,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      reporterId: json['reporter_id'] as String,
      reportedUserId: json['reported_user_id'] as String,
      reportedMessageId: json['reported_message_id'] as String,
      reason: json['reason'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      reportedUserName: json['reported_user_name'] as String?,
      reportedUserAvatar: json['reported_user_avatar'] as String?,
      messageContent: json['message_content'] as String?,
      reportCount: json['report_count'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporter_id': reporterId,
      'reported_user_id': reportedUserId,
      'reported_message_id': reportedMessageId,
      'reason': reason,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ReportModel copyWith({
    String? id,
    String? reporterId,
    String? reportedUserId,
    String? reportedMessageId,
    String? reason,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? reportedUserName,
    String? reportedUserAvatar,
    String? messageContent,
    int? reportCount,
  }) {
    return ReportModel(
      id: id ?? this.id,
      reporterId: reporterId ?? this.reporterId,
      reportedUserId: reportedUserId ?? this.reportedUserId,
      reportedMessageId: reportedMessageId ?? this.reportedMessageId,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reportedUserName: reportedUserName ?? this.reportedUserName,
      reportedUserAvatar: reportedUserAvatar ?? this.reportedUserAvatar,
      messageContent: messageContent ?? this.messageContent,
      reportCount: reportCount ?? this.reportCount,
    );
  }
}
