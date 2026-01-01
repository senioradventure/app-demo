import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class AcceptRequest extends NotificationEvent {
  final String requestId;
  final String userName;
  final String imageUrl;

  const AcceptRequest({
    required this.requestId,
    required this.userName,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [requestId];
}

class RejectRequest extends NotificationEvent {
  final String requestId;

  const RejectRequest({
    required this.requestId,
  });

  @override
  List<Object?> get props => [requestId];
}
