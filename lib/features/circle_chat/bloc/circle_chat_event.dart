import 'package:equatable/equatable.dart';
import 'package:senior_circle/features/circle_chat/models/circle_chat_message_model.dart';

abstract class CircleChatEvent extends Equatable {
  const CircleChatEvent();

  @override
  List<Object?> get props => [];
}

class GroupMessageInserted extends CircleChatEvent {
  final CircleChatMessage message;
 const GroupMessageInserted(this.message);
}


class LoadGroupMessages extends CircleChatEvent {
  final String chatId;

  const LoadGroupMessages({required this.chatId});
}

class SendMessage extends CircleChatEvent {
  final String? text;
  final String? imagePath;

  const SendMessage({this.text, this.imagePath});

  @override
  List<Object?> get props => [text];
}

class SendImageMessage extends CircleChatEvent {
  final String imagePath;
  

  const SendImageMessage({required this.imagePath});
}


class DeleteGroupMessage extends CircleChatEvent {
  final String messageId;
  final bool forEveryone;

  const DeleteGroupMessage({
    required this.messageId,
    required this.forEveryone,
  });

  @override
  List<Object?> get props => [messageId, forEveryone];
}

class SendGroupMessage extends CircleChatEvent {
  final String? circleId;
  final String? text;
  final String? imagePath;
  final String? mediaType;
  final String? replyToMessageId;

  const SendGroupMessage({
    this.circleId,
    this.text,
    this.imagePath,
    this.mediaType,
    this.replyToMessageId,
  });
}

class GroupReactionChanged extends CircleChatEvent {
  final String messageId;
  final String emoji;
  final String userId;
  final bool isAdded;

  const GroupReactionChanged({
    required this.messageId,
    required this.emoji,
    required this.userId,
    required this.isAdded,
  });
}


class ToggleReaction extends CircleChatEvent {
  final String messageId;
  final String emoji;
  final String userId;

  const ToggleReaction({
    required this.messageId,
    required this.emoji,
    required this.userId,
  });

  @override
  List<Object?> get props => [messageId, emoji, userId];
}

class ToggleGroupThread extends CircleChatEvent {
  final String messageId;

  const ToggleGroupThread({required this.messageId});
}

class AddGroupReply extends CircleChatEvent {
  final String parentMessageId;
  final String text;

  const AddGroupReply({required this.parentMessageId, required this.text});
}

class ToggleReplyInput extends CircleChatEvent {
  final String messageId;

  const ToggleReplyInput({required this.messageId});
}

class ToggleStar extends CircleChatEvent {
  final String messageId;
  final String userId;

  const ToggleStar({required this.messageId, required this.userId});

  @override
  List<Object?> get props => [messageId, userId];
}

class ForwardMessage extends CircleChatEvent {
  final CircleChatMessage message;
  final List<Map<String, String?>> individualTargets;
  final List<String> circleIds;

  const ForwardMessage({
    required this.message,
    required this.individualTargets,
    this.circleIds = const [],
  });

  @override
  List<Object?> get props => [message, individualTargets, circleIds];
}

class ForwardToSingleUser extends CircleChatEvent {
  final String text;

  const ForwardToSingleUser({required this.text});
}

class ClearForwardingState extends CircleChatEvent {}

// Media handling events
class PickMessageImage extends CircleChatEvent {
  final String imagePath;
  const PickMessageImage(this.imagePath);
  
  @override
  List<Object?> get props => [imagePath];
}

class PickMessageFile extends CircleChatEvent {
  final String filePath;
  const PickMessageFile(this.filePath);
  
  @override
  List<Object?> get props => [filePath];
}

class RemovePickedImage extends CircleChatEvent {}

class RemovePickedFile extends CircleChatEvent {}

class SendVoiceMessage extends CircleChatEvent {
  final String audioFile;
  const SendVoiceMessage({required this.audioFile});
  
  @override
  List<Object?> get props => [audioFile];
}
