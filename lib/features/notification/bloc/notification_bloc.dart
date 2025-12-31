import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/notification/notification_repository.dart';
import '../models/sent_request_model.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc(this.repository) : super(NotificationLoading()) {

    on<LoadNotifications>(_onLoadNotifications);
    on<AcceptRequest>(_onAcceptRequest);
    on<RejectRequest>(_onRejectRequest);
  }

  void _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    print('🔥 LoadNotifications event triggered');
  emit(NotificationLoading());

  try {
    final received = await repository.getReceivedRequests();
    final sent = await repository.getSentRequests();

    emit(
      NotificationLoaded(
        received: received,
        sent: sent,
      ),
    );
  } catch (e) {
    emit(
      const NotificationError(
       'Failed to load notifications'
      ),
    );
  }
}
void _onAcceptRequest(
  AcceptRequest event,
  Emitter<NotificationState> emit,
) async {
  if (state is! NotificationLoaded) return;

  final current = state as NotificationLoaded;

  try {
    await repository.acceptRequest(event.requestId);

    final updatedReceived =
        current.received.where((e) => e.id != event.requestId).toList();

    final updatedSent = [
      ...current.sent,
      SentRequestModel(
        id: event.requestId,
        name: event.userName,
        imageUrl: event.imageUrl,
        status: RequestStatus.accepted,
        time: 'Just now',
      ),
    ];

    emit(
      current.copyWith(
        received: updatedReceived,
        sent: updatedSent,
      ),
    );
  } catch (e) {
    emit(const NotificationError('Failed to accept request'));
    emit(current); // restore state
  }
}



 void _onRejectRequest(
  RejectRequest event,
  Emitter<NotificationState> emit,
) async {
  if (state is! NotificationLoaded) return;

  final current = state as NotificationLoaded;

  try {
    await repository.rejectRequest(event.requestId);

    final updatedReceived =
        current.received.where((e) => e.id != event.requestId).toList();

    emit(
      current.copyWith(
        received: updatedReceived,
      ),
    );
  } catch (e) {
    emit(const NotificationError('Failed to reject request'));
    emit(current);
  }
}


}
