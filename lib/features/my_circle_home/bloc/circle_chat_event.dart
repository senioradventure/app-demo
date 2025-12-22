import 'package:equatable/equatable.dart';

abstract class CirleChatEvent extends Equatable {
  const CirleChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChats extends CirleChatEvent {}

class FilterChats extends CirleChatEvent {
  final String query;

  const FilterChats(this.query);

  @override
  List<Object?> get props => [query];
}
