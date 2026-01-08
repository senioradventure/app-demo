import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/my_circle_home/models/my_circle_model.dart';
import 'package:senior_circle/features/my_circle_home/repository/my_circle_repository.dart';
import 'my_circle_event.dart';
import 'my_circle_state.dart';

class MyCircleBloc extends Bloc<MyCirleEvent, MyCircleState> {
  final MyCircleRepository repository;

  MyCircleBloc({required this.repository}) : super(MyCircleChatLoading()) {
    on<LoadMyCircleChats>(_onLoadChats);
    on<FilterMyCircleChats>(_onFilterMyCircleChats);
  }

  List<MyCircle> _allMyCircleChats = [];

  Future<void> _onLoadChats(
    LoadMyCircleChats event,
    Emitter<MyCircleState> emit,
  ) async {
    emit(MyCircleChatLoading());

    try {
      _allMyCircleChats = await repository.fetchMyCircleChats();
      emit(MyCircleChatLoaded(_allMyCircleChats));
    } catch (e) {
      emit(MyCircleChatError(e.toString()));
    }
  }

  void _onFilterMyCircleChats(FilterMyCircleChats event, Emitter<MyCircleState> emit) {
    final filtered = _allMyCircleChats
        .where(
          (chat) => chat.name.toLowerCase().contains(event.query.toLowerCase()),
        )
        .toList();

    emit(MyCircleChatLoaded(filtered));
  }
}
