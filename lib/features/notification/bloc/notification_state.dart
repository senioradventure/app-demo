import 'package:equatable/equatable.dart';
import '../models/recieved_request_model.dart';
import '../models/sent_request_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationLoading extends NotificationState {}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationLoaded extends NotificationState {
  final List<ReceivedRequestModel> received;
  final List<SentRequestModel> sent;

  const NotificationLoaded({
    required this.received,
    required this.sent,
  });

  NotificationLoaded copyWith({
    List<ReceivedRequestModel>? received,
    List<SentRequestModel>? sent,
  }) {
    return NotificationLoaded(
      received: received ?? this.received,
      sent: sent ?? this.sent,
    );
  }

  @override
  List<Object?> get props => [received, sent];
}
