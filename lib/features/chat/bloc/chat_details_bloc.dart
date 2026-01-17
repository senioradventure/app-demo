import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repositories/chat_details_repository.dart';
import '../repositories/chat_details_local_repository.dart';
import '../models/chat_details_models.dart';
import 'chat_details_event.dart';
import 'chat_details_state.dart';

class ChatDetailsBloc extends Bloc<ChatDetailsEvent, ChatDetailsState> {
  final ChatDetailsRepository _repository;
  final ChatDetailsLocalRepository _localRepository;

  ChatDetailsBloc(this._repository, this._localRepository)
    : super(ChatDetailsInitial()) {
    on<LoadChatDetails>(_onLoadChatDetails);
  }

  Future<void> _onLoadChatDetails(
    LoadChatDetails event,
    Emitter<ChatDetailsState> emit,
  ) async {
    emit(ChatDetailsLoading());

    // 1. Try Local First
    try {
      final localDetails = await _localRepository.getChatDetails(event.chatId);
      final localMembers = await _localRepository.getMembers(event.chatId);

      if (localDetails != null) {
        final (isAdmin, currentUserId) = _calculateAdminStatus(
          localDetails,
          localMembers,
        );
        emit(
          ChatDetailsLoaded(
            details: localDetails,
            members: localMembers,
            isAdmin: isAdmin,
            currentUserId: currentUserId,
          ),
        );
      }
    } catch (e) {
      // Ignore local errors, proceed to remote
      // debugPrint("Local load failed: $e");
    }

    // 2. Fetch Remote
    try {
      final details = await _repository.getChatDetails(
        event.chatId,
        event.type,
      );
      final members = await _repository.getChatMembers(
        event.chatId,
        event.type,
      );

      // Save to Local
      await _localRepository.saveChatDetails(details);
      await _localRepository.saveMembers(event.chatId, members);

      final (isAdmin, currentUserId) = _calculateAdminStatus(details, members);

      emit(
        ChatDetailsLoaded(
          details: details,
          members: members,
          isAdmin: isAdmin,
          currentUserId: currentUserId,
        ),
      );
    } catch (e) {
      // If we haven't emitted any data yet (state is Loading), emit Error
      if (state is ChatDetailsLoading) {
        emit(ChatDetailsError(e.toString()));
      }
      // If we already emitted local data, we could emit a specialized state or just do nothing (keeping local data visible)
      // For now, if we have local data, we suppress the error effectively from the UI state perspective (or show a snackbar via a side effect listener - but here simply keeping state is fine).
    }
  }

  (bool, String?) _calculateAdminStatus(
    ChatDetailsModel details,
    List<ChatMember> members,
  ) {
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
    return (isAdmin, currentUserId);
  }
}
