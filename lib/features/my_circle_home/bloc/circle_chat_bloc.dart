import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/my_circle_home/models/circle_chat_model.dart';
import 'package:senior_circle/features/my_circle_home/repository/chat_repository.dart';
import 'circle_chat_event.dart';
import 'circle_chat_state.dart';

class CircleChatBloc extends Bloc<CirleChatEvent, CircleChatState> {
  final ChatRepository repository;

  CircleChatBloc({required this.repository}) : super(ChatLoading()) {
    on<LoadChats>(_onLoadChats);
    on<FilterChats>(_onFilterChats);
  }

  List<CircleChat> _allChats = [];

  Future<void> _onLoadChats(
    LoadChats event,
    Emitter<CircleChatState> emit,
  ) async {
    emit(ChatLoading());

    try {
      _allChats = await repository.fetchChats();
      emit(ChatLoaded(_allChats));
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void _onFilterChats(FilterChats event, Emitter<CircleChatState> emit) {
    final filtered = _allChats
        .where(
          (chat) => chat.name.toLowerCase().contains(event.query.toLowerCase()),
        )
        .toList();

    emit(ChatLoaded(filtered));
  }
}
