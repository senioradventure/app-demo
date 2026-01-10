import 'package:equatable/equatable.dart';

abstract class MyCirleEvent extends Equatable {
  const MyCirleEvent();

  @override
  List<Object?> get props => [];
}

class LoadMyCircleChats extends MyCirleEvent {}

class FilterMyCircleChats extends MyCirleEvent {
  final String query;

  const FilterMyCircleChats(this.query);

  @override
  List<Object?> get props => [query];
}
