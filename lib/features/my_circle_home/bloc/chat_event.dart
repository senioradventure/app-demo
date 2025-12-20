import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class LoadChats extends ChatEvent {}

class FilterChats extends ChatEvent {
  final String query;

  const FilterChats(this.query);

  @override
  List<Object?> get props => [query];
}
