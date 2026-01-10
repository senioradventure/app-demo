import 'package:equatable/equatable.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import '../../../core/enum/chat_message_type.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class GroupMessageInserted extends ChatEvent {
  final GroupMessage message;
 const GroupMessageInserted(this.message);
}


class LoadGroupMessages extends ChatEvent {
  final String chatId;

  const LoadGroupMessages({required this.chatId});
}

class SendMessage extends ChatEvent {
  final String? text;
  final String? imagePath;

  const SendMessage({this.text, this.imagePath});

  @override
  List<Object?> get props => [text];
}

class SendImageMessage extends ChatEvent {
  final String imagePath;
  

  const SendImageMessage({required this.imagePath});
}


class DeleteGroupMessage extends ChatEvent {
  final String messageId;
  final bool forEveryone;

  const DeleteGroupMessage({
    required this.messageId,
    required this.forEveryone,
  });

  @override
  List<Object?> get props => [messageId, forEveryone];
}

class SendGroupMessage extends ChatEvent {
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

class GroupReactionChanged extends ChatEvent {
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


class ToggleReaction extends ChatEvent {
  final String messageId;
  final String emoji;
  final String userId;
  final ChatMessageType type;

  const ToggleReaction({
    required this.messageId,
    required this.emoji,
    required this.userId,
    required this.type,
  });

  @override
  List<Object?> get props => [messageId, emoji, userId, type];
}

class ToggleGroupThread extends ChatEvent {
  final String messageId;

  const ToggleGroupThread({required this.messageId});
}

class AddGroupReply extends ChatEvent {
  final String parentMessageId;
  final String text;

  const AddGroupReply({required this.parentMessageId, required this.text});
}

class ToggleReplyInput extends ChatEvent {
  final String messageId;

  const ToggleReplyInput({required this.messageId});
}

class ToggleStar extends ChatEvent {
  final String messageId;
  final String userId;

  const ToggleStar({required this.messageId, required this.userId});

  @override
  List<Object?> get props => [messageId, userId];
}

class ForwardMessage extends ChatEvent {
  final GroupMessage message;
  final List<String> conversationIds;
  final List<String> circleIds;

  ForwardMessage({
    required this.message,
    required this.conversationIds,
    this.circleIds = const [],
  });
}

class ForwardToSingleUser extends ChatEvent {
  final String text;

  ForwardToSingleUser({required this.text});
}