import 'package:equatable/equatable.dart';
import '../models/report_model.dart';

abstract class AdminReportsEvent extends Equatable {
  const AdminReportsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAdminReports extends AdminReportsEvent {
  final String chatId;

  const LoadAdminReports(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class AdminReportsUpdated extends AdminReportsEvent {
  final List<ReportModel> reports;

  const AdminReportsUpdated(this.reports);

  @override
  List<Object?> get props => [reports];
}

class DismissAdminReport extends AdminReportsEvent {
  final String reportedMessageId;

  const DismissAdminReport(this.reportedMessageId);

  @override
  List<Object?> get props => [reportedMessageId];
}

class DeleteAdminReportedMessage extends AdminReportsEvent {
  final String messageId;

  const DeleteAdminReportedMessage(this.messageId);

  @override
  List<Object?> get props => [messageId];
}
