import 'package:flutter/material.dart';
import 'package:senior_circle/core/common/widgets/bottom_button.dart';
import 'package:senior_circle/core/common/widgets/search_bar_widget.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_bloc.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_event.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/view_friends/models/friends_model.dart';
import 'package:senior_circle/features/view_friends/repository/view_friends_repository.dart';
import 'package:senior_circle/features/individual_chat/bloc/individual_chat_bloc.dart';
import 'package:senior_circle/features/individual_chat/presentation/my_circle_individual_chat_page.dart';
import 'package:senior_circle/features/individual_chat/repositories/individual_chat_repository.dart';
import 'package:senior_circle/features/my_circle_home/repository/my_circle_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ForwardItem {
  final String id;
  final String name;
  final String avatarUrl;

  ForwardItem({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });
}


class ForwardBottomSheet extends StatefulWidget {
  final GroupMessage message;

  const ForwardBottomSheet({super.key, required this.message});

  @override
  State<ForwardBottomSheet> createState() => _ForwardBottomSheetState();
}

class _ForwardBottomSheetState extends State<ForwardBottomSheet> {
  final TextEditingController _searchController = TextEditingController();

  List<Friend> allItems = [];
  List<Friend> filteredItems = [];
  final Set<String> selectedIds = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final repository = ViewFriendsRepository(Supabase.instance.client);
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final friends = await repository.getFriends(userId);

      if (mounted) {
        setState(() {
          allItems = friends;
          filteredItems = friends;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading friends for forward: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _onSearch(String value) {
    setState(() {
      filteredItems = allItems
          .where(
            (e) => e.name.toLowerCase().contains(value.toLowerCase()),
          )
          .toList();
    });
  }

  void _toggleSelection(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else {
        selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: Column(
          children: [
            _header(),
          SearchBarWidget( 
            hintText: 'Search',   
              onChanged: _onSearch,
            ),
            Flexible(child: _list()),
            BottomButton(buttonText: 'FORWARD', onTap: () {
              _forward();
            },)
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const Text(
            'Forward',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          if (selectedIds.isNotEmpty)
            Text(
              '${selectedIds.length} selected',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }

  Widget _list() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (filteredItems.isEmpty) {
      return const Center(child: Text('No friends found'));
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 8),
      itemCount: filteredItems.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final isSelected = selectedIds.contains(item.id);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: item.profileImage != null && item.profileImage!.isNotEmpty
                ? NetworkImage(item.profileImage!)
                : null,
            child: item.profileImage == null || item.profileImage!.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),
          title: Text(item.name),
          trailing: Checkbox(
            value: isSelected,
            onChanged: (_) => _toggleSelection(item.id),
          ),
          onTap: () => _toggleSelection(item.id),
        );
      },
    );
  }


  Future<void> _forward() async {
    if (selectedIds.isEmpty) return;

    final selectedReceiverIds = selectedIds.toList();

    if (selectedReceiverIds.length == 1) {
      final receiverId = selectedReceiverIds.first;
      
      // 1. Find the conversation for this user
      try {
        final repo = MyCircleRepository();
        final chats = await repo.fetchMyCircleChats();
        
        final individualChat = chats.firstWhere(
          (c) => c.otherUserId == receiverId,
        );

        if (!mounted) return;

        // 2. Navigate and prefill
        Navigator.pop(context); // Close bottom sheet
        
        // We need to navigate to the individual chat room.
        // The MyCircleHomePage.navigateToChatRoom logic uses BlocProvider.
        // We can replicate that or just navigate.
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => IndividualChatBloc(IndividualChatRepository())
                ..add(LoadConversationMessages(individualChat.id))
                ..add(PrefillIndividualChat(
                  text: widget.message.text,
                  mediaUrl: widget.message.imagePath,
                )),
              child: MyCircleIndividualChatPage(chat: individualChat),
            ),
          ),
        );
        return;
      } catch (e) {
        debugPrint('Could not find existing conversation for $receiverId: $e');
        // If no conversation exists, we fall back to multi-forward or show error
        // For now, let's proceed with multi-forward logic if conversation not found
      }
    }

    // Multi-forward logic (already implemented in Bloc)
    debugPrint('Forwarding message to $selectedReceiverIds');

    context.read<ChatBloc>().add(
          ForwardMessage(
            message: widget.message,
            receiverIds: selectedReceiverIds,
          ),
        );

    Navigator.pop(context);
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(selectedReceiverIds.length == 1 
          ? 'Message forwarded successfully' 
          : 'Message forwarded successfully'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
