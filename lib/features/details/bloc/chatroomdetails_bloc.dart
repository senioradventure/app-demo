import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chatroomdetails_event.dart';
part 'chatroomdetails_state.dart';

class ChatroomdetailsBloc
    extends Bloc<ChatroomdetailsEvent, ChatroomdetailsState> {
  ChatroomdetailsBloc() : super(ChatroomdetailsInitial(showAll: false)) {
    on<ToggleShowMoreEvent>((event, emit) {
      final current = state as ChatroomdetailsInitial;
      emit(current.copyWith(showAll: !current.showAll));
    });
  }
}
