import 'package:equatable/equatable.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/forward_item_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/my_circle_home/models/my_circle_model.dart';

abstract class ForwardState extends Equatable {
  const ForwardState();

  @override
  List<Object?> get props => [];
}

class ForwardInitial extends ForwardState {}

class ForwardLoading extends ForwardState {}

class ForwardLoaded extends ForwardState {
  final List<ForwardItem> allItems;
  final List<ForwardItem> filteredItems;
  final Set<ForwardItem> selectedItems;

  const ForwardLoaded({
    required this.allItems,
    required this.filteredItems,
    required this.selectedItems,
  });

  ForwardLoaded copyWith({
    List<ForwardItem>? allItems,
    List<ForwardItem>? filteredItems,
    Set<ForwardItem>? selectedItems,
  }) {
    return ForwardLoaded(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }

  @override
  List<Object?> get props => [allItems, filteredItems, selectedItems];
}

class ForwardSuccess extends ForwardState {
  final String message;

  const ForwardSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ForwardNavigateToGroup extends ForwardState {
  final MyCircle chat;
  final GroupMessage message;
  final bool isAdmin;

  const ForwardNavigateToGroup({
    required this.chat,
    required this.message,
    required this.isAdmin,
  });

  @override
  List<Object?> get props => [chat, message, isAdmin];
}

class ForwardNavigateToIndividual extends ForwardState {
  final MyCircle chat;
  final GroupMessage message;

  const ForwardNavigateToIndividual({
    required this.chat,
    required this.message,
  });

  @override
  List<Object?> get props => [chat, message];
}

class ForwardError extends ForwardState {
  final String message;

  const ForwardError(this.message);

  @override
  List<Object?> get props => [message];
}
