import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/features/my_circle_home/models/my_circle_model.dart';
import 'package:senior_circle/features/my_circle_home/repository/my_circle_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'my_circle_event.dart';
import 'my_circle_state.dart';

class MyCircleBloc extends Bloc<MyCirleEvent, MyCircleState> {
  final MyCircleRepository repository;
  RealtimeChannel? _messageSubscription;

  MyCircleBloc({required this.repository}) : super(MyCircleChatLoading()) {
    on<LoadMyCircleChats>(_onLoadChats);
    on<FilterMyCircleChats>(_onFilterMyCircleChats);

    _initRealtime();
  }

  List<MyCircle> _allMyCircleChats = [];

  void _initRealtime() {
    debugPrint('🟦 [MyCircleBloc] Initializing real-time subscription');
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    _messageSubscription = Supabase.instance.client
        .channel('my_circle_messages_refresh')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            debugPrint('🟨 [MyCircleBloc] New message detected, refreshing list...');
            add(LoadMyCircleChats());
          },
        )
        .subscribe();
  }

  Future<void> _onLoadChats(
    LoadMyCircleChats event,
    Emitter<MyCircleState> emit,
  ) async {
    // Only show loading if we don't have data yet to avoid flickering
    if (_allMyCircleChats.isEmpty) {
      emit(MyCircleChatLoading());
    }

    try {
      _allMyCircleChats = await repository.fetchMyCircleChats();
      emit(MyCircleChatLoaded(_allMyCircleChats));
    } catch (e) {
      emit(MyCircleChatError(e.toString()));
    }
  }

  void _onFilterMyCircleChats(FilterMyCircleChats event, Emitter<MyCircleState> emit) {
    if (event.query.isEmpty) {
      emit(MyCircleChatLoaded(_allMyCircleChats));
      return;
    }

    final filtered = _allMyCircleChats
        .where(
          (chat) => chat.name.toLowerCase().contains(event.query.toLowerCase()),
        )
        .toList();

    emit(MyCircleChatLoaded(filtered));
  }

  @override
  Future<void> close() {
    _messageSubscription?.unsubscribe();
    return super.close();
  }
}
