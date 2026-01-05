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

  /// 🔥 ADD THIS
  final int version;

  const IndividualChatLoaded({
    required this.messages,
    this.imagePath,
    this.isSending = false,
    this.replyTo,
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
  }) {
    return IndividualChatLoaded(
      messages: messages ?? this.messages,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      isSending: isSending ?? this.isSending,
      replyTo: clearReplyTo ? null : (replyTo ?? this.replyTo),

      /// 🔥 INCREMENT VERSION ON EVERY EMIT
      version: version + 1,
    );
  }

  @override
  List<Object?> get props => [
    version, // 🔥 FIRST
    messages,
    imagePath,
    isSending,
    replyTo,
  ];
}

class IndividualChatError extends IndividualChatState {
  final String message;
  const IndividualChatError(this.message);

  @override
  List<Object?> get props => [message];
}
