part of 'individual_chat_bloc.dart';

sealed class IndividualChatState extends Equatable {
  const IndividualChatState();

  @override
  List<Object?> get props => [];
}

class IndividualChatInitial extends IndividualChatState {}

class IndividualChatLoading extends IndividualChatState {}

class IndividualChatLoaded extends IndividualChatState {
  final List<IndividualChatMessageModel> messages;
  final bool isSending;
  final IndividualChatMessageModel? replyTo;
  final String? prefilledInputText;
  final String? prefilledMediaUrl;
  final String? imagePath;
  final String? filePath;
  final String? voicePath;

  final int version;

  const IndividualChatLoaded({
    required this.messages,
    required this.isSending,
    this.replyTo,
    this.imagePath,
    this.filePath,
    this.voicePath,
    this.prefilledInputText,
    this.prefilledMediaUrl,
    this.version = 0,
  });

  IndividualChatLoaded copyWith({
    List<IndividualChatMessageModel>? messages,
    bool? isSending,
    IndividualChatMessageModel? replyTo,
    bool clearReplyTo = false,
    String? imagePath,
    bool clearImagePath = false,

    /// ✅ ADD
    String? filePath,
    String? voicePath,
    bool clearFilePath = false,
    bool clearVoicePath = false,

    int? version,
    String? prefilledInputText,
    String? prefilledMediaUrl,
  }) {
    return IndividualChatLoaded(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      replyTo: clearReplyTo ? null : replyTo ?? this.replyTo,
      imagePath: clearImagePath ? null : imagePath ?? this.imagePath,
      prefilledInputText: prefilledInputText ?? this.prefilledInputText,
      prefilledMediaUrl: prefilledMediaUrl ?? this.prefilledMediaUrl,

      /// ✅ ADD
      filePath: clearFilePath ? null : filePath ?? this.filePath,
      voicePath: clearVoicePath ? null : voicePath ?? this.voicePath,

      version: version ?? this.version,
    );
  }

  @override
  List<Object?> get props => [
    version,
    messages,
    isSending,
    replyTo,
    prefilledInputText,
    prefilledMediaUrl,
    imagePath,
    filePath,
    voicePath,
  ];
}

/// ─────────────────────────────────────────
/// 🔔 ONE-TIME UI STATES (Snackbars)
/// ─────────────────────────────────────────

class StarMessageSuccess extends IndividualChatState {
  final String message;
  const StarMessageSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class StarMessageFailure extends IndividualChatState {
  final String error;
  const StarMessageFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class IndividualChatError extends IndividualChatState {
  final String message;
  const IndividualChatError(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteMessageSuccess extends IndividualChatState {
  final String message;
  const DeleteMessageSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteMessageFailure extends IndividualChatState {
  final String error;
  const DeleteMessageFailure(this.error);

  @override
  List<Object?> get props => [error];
}
