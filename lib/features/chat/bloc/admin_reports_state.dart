import 'package:equatable/equatable.dart';
import '../models/report_model.dart';

abstract class AdminReportsState extends Equatable {
  const AdminReportsState();

  @override
  List<Object?> get props => [];
}

class AdminReportsInitial extends AdminReportsState {}

class AdminReportsLoading extends AdminReportsState {}

class AdminReportsLoaded extends AdminReportsState {
  final List<ReportModel> reports;

  const AdminReportsLoaded(this.reports);

  @override
  List<Object?> get props => [reports];
}

class AdminReportsError extends AdminReportsState {
  final String message;

  const AdminReportsError(this.message);

  @override
  List<Object?> get props => [message];
}

class AdminReportActionInProgress extends AdminReportsState {
  final List<ReportModel> reports;
  final String actionMessageId;

  const AdminReportActionInProgress(this.reports, this.actionMessageId);

  @override
  List<Object?> get props => [reports, actionMessageId];
}
