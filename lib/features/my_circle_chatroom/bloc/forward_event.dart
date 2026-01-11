import 'package:equatable/equatable.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/forward_item_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';

abstract class ForwardEvent extends Equatable {
  const ForwardEvent();

  @override
  List<Object?> get props => [];
}

class LoadForwardTargets extends ForwardEvent {}

class FilterTargets extends ForwardEvent {
  final String query;

  const FilterTargets(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleSelection extends ForwardEvent {
  final ForwardItem item;

  const ToggleSelection(this.item);

  @override
  List<Object?> get props => [item];
}

class SubmitForward extends ForwardEvent {
  final GroupMessage message;

  const SubmitForward(this.message);

  @override
  List<Object?> get props => [message];
}
