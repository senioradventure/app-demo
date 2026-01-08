import 'package:equatable/equatable.dart';
import '../models/my_circle_model.dart';

abstract class MyCircleState extends Equatable {
  const MyCircleState();

  @override
  List<Object?> get props => [];
}

class MyCircleChatLoading extends MyCircleState {}

class MyCircleChatLoaded extends MyCircleState {
  final List<MyCircle> chats;

  const MyCircleChatLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class MyCircleChatError extends MyCircleState {
  final String message;

  const MyCircleChatError(this.message);

  @override
  List<Object?> get props => [message];
}
