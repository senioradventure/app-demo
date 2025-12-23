import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'live_chat_home_event.dart';
part 'live_chat_home_state.dart';

class LiveChatHomeBloc extends Bloc<LiveChatHomeEvent, LiveChatHomeState> {
  LiveChatHomeBloc() : super(LiveChatHomeInitial()) {
    on<LiveChatHomeEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
