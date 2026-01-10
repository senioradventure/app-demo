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
  final String? imagePath;
  final bool isSending;
  final IndividualChatMessageModel? replyTo;
  final String? prefilledInputText;
  final String? prefilledMediaUrl;

  /// 🔥 VERSION FOR FORCING UI REBUILD
  final int version;

  const IndividualChatLoaded({
    required this.messages,
    this.imagePath,
    this.isSending = false,
    this.replyTo,
    this.prefilledInputText,
    this.prefilledMediaUrl,
    this.version = 0,
  });

  bool get canSend => imagePath != null;

  IndividualChatLoaded copyWith({
    List<IndividualChatMessageModel>? messages,
    String? imagePath,
    bool? isSending,
    IndividualChatMessageModel? replyTo,
    bool clearImagePath = false,
    bool clearReplyTo = false,
    String? prefilledInputText,
    String? prefilledMediaUrl,
  }) {
    return IndividualChatLoaded(
      messages: messages ?? this.messages,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      isSending: isSending ?? this.isSending,
      replyTo: clearReplyTo ? null : (replyTo ?? this.replyTo),
      prefilledInputText: prefilledInputText ?? this.prefilledInputText,
      prefilledMediaUrl: prefilledMediaUrl ?? this.prefilledMediaUrl,

      /// 🔥 FORCE REBUILD
      version: version + 1,
    );
  }

  @override
  List<Object?> get props => [
    version, // 🔥 MUST BE FIRST
    messages,
    imagePath,
    isSending,
    replyTo,
    prefilledInputText,
    prefilledMediaUrl,
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
