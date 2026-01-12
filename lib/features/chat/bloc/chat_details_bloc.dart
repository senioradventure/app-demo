//import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/chat_details_repository.dart';
import '../models/chat_details_models.dart';
import 'chat_details_event.dart';
import 'chat_details_state.dart';

class ChatDetailsBloc extends Bloc<ChatDetailsEvent, ChatDetailsState> {
  final ChatDetailsRepository _repository;

  ChatDetailsBloc(this._repository) : super(ChatDetailsInitial()) {
    on<LoadChatDetails>(_onLoadChatDetails);
  }

  Future<void> _onLoadChatDetails(
    LoadChatDetails event,
    Emitter<ChatDetailsState> emit,
  ) async {
    emit(ChatDetailsLoading());

    try {
      final details = await _repository.getChatDetails(
        event.chatId,
        event.type,
      );
      final members = await _repository.getChatMembers(
        event.chatId,
        event.type,
      );

      final currentUserId = Supabase.instance.client.auth.currentUser?.id;

      // Determine if current user is admin
      // 1. Check if user is the creator/admin of the chat object
      bool isAdmin = details.adminId == currentUserId;

      // 2. Or check if user has admin role in members list
      if (!isAdmin && currentUserId != null) {
        final member = members.firstWhere(
          (m) => m.userId == currentUserId,
          orElse: () => ChatMember(userId: '', role: ChatRole.member),
        );
        isAdmin = member.isAdmin;
      }

      // DEBUG LOGGING
      /*debugPrint('🟦 [ChatDetailsBloc] DEBUG INFO:');
      debugPrint('   Current User ID: $currentUserId');
      debugPrint('   Chat Admin ID: ${details.adminId}');
      debugPrint('   Calculated IsAdmin: $isAdmin');
      debugPrint('   Chat Type: ${details.type}');*/

      emit(
        ChatDetailsLoaded(
          details: details,
          members: members,
          isAdmin: isAdmin,
          currentUserId: currentUserId,
        ),
      );
    } catch (e) {
      emit(ChatDetailsError(e.toString()));
    }
  }
}
