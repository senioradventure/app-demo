import 'package:equatable/equatable.dart';
import '../models/chat_details_models.dart';

abstract class ChatDetailsState extends Equatable {
  const ChatDetailsState();

  @override
  List<Object?> get props => [];
}

class ChatDetailsInitial extends ChatDetailsState {}

class ChatDetailsLoading extends ChatDetailsState {}

class ChatDetailsLoaded extends ChatDetailsState {
  final ChatDetailsModel details;
  final List<ChatMember> members;
  final bool isAdmin;
  final String? currentUserId;

  const ChatDetailsLoaded({
    required this.details,
    required this.members,
    required this.isAdmin,
    this.currentUserId,
  });

  @override
  List<Object?> get props => [details, members, isAdmin, currentUserId];
}

class ChatDetailsError extends ChatDetailsState {
  final String message;

  const ChatDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
