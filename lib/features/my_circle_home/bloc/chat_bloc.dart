import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/my_circle_home/models/circle_chat_model.dart';
import 'package:senior_circle/features/my_circle_home/repository/chat_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repository;

  ChatBloc({required this.repository}) : super(ChatLoading()) {
    on<LoadChats>(_onLoadChats);
    on<FilterChats>(_onFilterChats);
  }

  List<CircleChat> _allChats = [];

  Future<void> _onLoadChats(
    LoadChats event,
    Emitter<ChatState> emit,
  ) async {
    emit(ChatLoading());

    try {
      _allChats = await repository.fetchChats();
      emit(ChatLoaded(_allChats));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onFilterChats(
    FilterChats event,
    Emitter<ChatState> emit,
  ) {
    final filtered = _allChats
        .where((chat) =>
            chat.name.toLowerCase().contains(event.query.toLowerCase()))
        .toList();

    emit(ChatLoaded(filtered));
  }
}
