import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/admin_reports_repository.dart';
import 'admin_reports_event.dart';
import 'admin_reports_state.dart';

class AdminReportsBloc extends Bloc<AdminReportsEvent, AdminReportsState> {
  final AdminReportsRepository _repository;
  RealtimeChannel? _reportsSubscription;

  AdminReportsBloc(this._repository) : super(AdminReportsInitial()) {
    on<LoadAdminReports>(_onLoadAdminReports);
    on<AdminReportsUpdated>(_onAdminReportsUpdated);
    on<DismissAdminReport>(_onDismissAdminReport);
    on<DeleteAdminReportedMessage>(_onDeleteAdminReportedMessage);
  }

  Future<void> _onLoadAdminReports(
    LoadAdminReports event,
    Emitter<AdminReportsState> emit,
  ) async {
    /*debugPrint(
      '🟦 [AdminReportsBloc] Loading reports for chat: ${event.chatId}',
    );*/
    emit(AdminReportsLoading());

    try {
      final reports = await _repository.fetchReportedMessages(
        chatId: event.chatId,
      );

      emit(AdminReportsLoaded(reports));

      // Subscribe to real-time updates
      _reportsSubscription?.unsubscribe();
      _reportsSubscription = _repository.subscribeToReports(
        chatId: event.chatId,
        onReportsUpdated: (updatedReports) {
          add(AdminReportsUpdated(updatedReports));
        },
      );

      /*debugPrint('🟩 [AdminReportsBloc] Reports loaded: ${reports.length}');*/
    } catch (e, stack) {
      /*debugPrint('🟥 [AdminReportsBloc] Error loading reports: $e');
      debugPrint('🟥 [AdminReportsBloc] STACKTRACE:\n$stack');*/
      emit(AdminReportsError(e.toString()));
    }
  }

  void _onAdminReportsUpdated(
    AdminReportsUpdated event,
    Emitter<AdminReportsState> emit,
  ) {
    /*debugPrint(
      '🟨 [AdminReportsBloc] Reports updated: ${event.reports.length}',
    );*/
    emit(AdminReportsLoaded(event.reports));
  }

  Future<void> _onDismissAdminReport(
    DismissAdminReport event,
    Emitter<AdminReportsState> emit,
  ) async {
    /*debugPrint(
      '🟦 [AdminReportsBloc] Dismissing report for message: ${event.reportedMessageId}',
    );*/

    final currentState = state;
    if (currentState is! AdminReportsLoaded) return;

    emit(
      AdminReportActionInProgress(
        currentState.reports,
        event.reportedMessageId,
      ),
    );

    try {
      await _repository.dismissReport(
        reportedMessageId: event.reportedMessageId,
      );

      // Remove the dismissed report from the list
      final updatedReports = currentState.reports
          .where((r) => r.reportedMessageId != event.reportedMessageId)
          .toList();

      emit(AdminReportsLoaded(updatedReports));
      debugPrint('🟩 [AdminReportsBloc] Report dismissed successfully');
    } catch (e, stack) {
      debugPrint('🟥 [AdminReportsBloc] Error dismissing report: $e');
      debugPrint('🟥 [AdminReportsBloc] STACKTRACE:\n$stack');
      emit(AdminReportsLoaded(currentState.reports));
      emit(AdminReportsError(e.toString()));
    }
  }

  Future<void> _onDeleteAdminReportedMessage(
    DeleteAdminReportedMessage event,
    Emitter<AdminReportsState> emit,
  ) async {
    /*debugPrint(
      '🟦 [AdminReportsBloc] Deleting reported message: ${event.messageId}',
    );*/

    final currentState = state;
    if (currentState is! AdminReportsLoaded) return;

    emit(AdminReportActionInProgress(currentState.reports, event.messageId));

    try {
      await _repository.deleteReportedMessage(messageId: event.messageId);

      // Remove the deleted message's report from the list
      final updatedReports = currentState.reports
          .where((r) => r.reportedMessageId != event.messageId)
          .toList();

      emit(AdminReportsLoaded(updatedReports));
      debugPrint('🟩 [AdminReportsBloc] Reported message deleted successfully');
    } catch (e, stack) {
      debugPrint('🟥 [AdminReportsBloc] Error deleting message: $e');
      debugPrint('🟥 [AdminReportsBloc] STACKTRACE:\n$stack');
      emit(AdminReportsLoaded(currentState.reports));
      emit(AdminReportsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _reportsSubscription?.unsubscribe();
    return super.close();
  }
}
