import 'package:flutter/material.dart';
import 'package:senior_circle/core/common/widgets/bottom_button.dart';
import 'package:senior_circle/core/common/widgets/search_bar_widget.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_bloc.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_event.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/page/my_circle_group_chat_page.dart';
import 'package:senior_circle/features/my_circle_chatroom/repositories/group_chat_reppository.dart';
import 'package:senior_circle/features/my_circle_home/models/my_circle_model.dart';
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
  final String? avatarUrl;
  final bool isGroup;
  final String? otherUserId;

  ForwardItem({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.isGroup,
    this.otherUserId,
  });
}


class ForwardBottomSheet extends StatefulWidget {
  final GroupMessage message;

  const ForwardBottomSheet({super.key, required this.message});

  @override
  State<ForwardBottomSheet> createState() => _ForwardBottomSheetState();
}

class _ForwardBottomSheetState extends State<ForwardBottomSheet> {

  List<ForwardItem> allItems = [];
  List<ForwardItem> filteredItems = [];
  final Set<ForwardItem> selectedItems = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    try {
      final friendsRepo = ViewFriendsRepository(Supabase.instance.client);
      final circlesRepo = MyCircleRepository();
      final userId = Supabase.instance.client.auth.currentUser!.id;

      final results = await Future.wait([
        friendsRepo.getFriends(userId),
        circlesRepo.fetchMyCircleChats(),
      ]);

      final friends = results[0] as List<Friend>;
      final chats = results[1] as List<MyCircle>;

      final List<ForwardItem> items = [];

      // 1. Add Circles (Groups)
      for (final chat in chats.where((c) => c.isGroup)) {
        items.add(ForwardItem(
          id: chat.id,
          name: chat.name,
          avatarUrl: chat.imageUrl,
          isGroup: true,
        ));
      }

      // 2. Add Friends (Individuals)
      for (final friend in friends) {
        // Find existing conversation for this friend
        final conversation = chats.firstWhere(
          (c) => !c.isGroup && c.otherUserId == friend.id,
          orElse: () => MyCircle(
            id: '', // Empty ID means no existing conversation
            name: friend.name,
            imageUrl: friend.profileImage,
            updatedAt: null,
            otherUserId: friend.id,
            createdAt: null,
          ),
        );

        items.add(ForwardItem(
          id: conversation.id, // Might be empty
          name: friend.name,
          avatarUrl: friend.profileImage,
          isGroup: false,
          otherUserId: friend.id,
        ));
      }

      if (mounted) {
        setState(() {
          allItems = items;
          filteredItems = items;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading forwarding targets: $e');
      if (mounted) {
        setState(() => isLoading = false);
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

  void _onItemToggle(ForwardItem item, bool selected) {
    setState(() {
      if (selected) {
        selectedItems.add(item);
      } else {
        selectedItems.remove(item);
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
          if (selectedItems.isNotEmpty)
            Text(
              '${selectedItems.length} selected',
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
      return const Center(child: Text('No targets found'));
    }

    return ListView.separated(
      padding: const EdgeInsets.only(top: 8),
      itemCount: filteredItems.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        final isSelected = selectedItems.contains(item);

        return ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                backgroundImage: item.avatarUrl != null && item.avatarUrl!.isNotEmpty
                    ? NetworkImage(item.avatarUrl!)
                    : null,
                child: item.avatarUrl == null || item.avatarUrl!.isEmpty
                    ? Icon(item.isGroup ? Icons.groups : Icons.person)
                    : null,
              ),
              if (item.isGroup)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.groups, size: 10, color: Colors.blue),
                  ),
                ),
            ],
          ),
          title: Text(item.name),
          subtitle: Text(item.isGroup ? 'Circle' : 'Friend'),
          trailing: Checkbox(
            value: isSelected,
            onChanged: (val) => _onItemToggle(item, val ?? false),
          ),
          onTap: () => _onItemToggle(item, !isSelected),
        );
      },
    );
  }


  Future<void> _forward() async {
    if (selectedItems.isEmpty) return;

    if (selectedItems.length == 1) {
      final item = selectedItems.first;
      if (item.isGroup) {
        await _forwardToCircle(item.id);
      } else {
        await _forwardToIndividual(item);
      }
      return;
    }

    debugPrint('Forwarding message to ${selectedItems.length} targets');

    final individualTargets = selectedItems
        .where((i) => !i.isGroup)
        .map((i) => {
              'conversationId': i.id,
              'otherUserId': i.otherUserId,
            })
        .toList();

    final circleIds = selectedItems.where((i) => i.isGroup).map((i) => i.id).toList();

    context.read<ChatBloc>().add(
          ForwardMessage(
            message: widget.message,
            individualTargets: individualTargets,
            circleIds: circleIds,
          ),
        );

    if (mounted) {
      Navigator.pop(context); 
      Navigator.of(context).pop(); 
      _showSuccess('Message forwarded successfully');
    }
  }

  Future<void> _forwardToIndividual(ForwardItem item) async {
    String conversationId = item.id;

    // If conversation doesn't exist, create it now
    if (conversationId.isEmpty && item.otherUserId != null) {
      try {
        final repo = GroupChatRepository(Supabase.instance.client);
        conversationId = await repo.getOrCreateConversation(item.otherUserId!);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to start conversation')),
          );
        }
        return;
      }
    }

    try {
      final individualChat = MyCircle(
        id: conversationId,
        name: item.name,
        imageUrl: item.avatarUrl,
        updatedAt: DateTime.now(),
        otherUserId: item.otherUserId,
        createdAt: null,
      );

      if (!mounted) return;

      Navigator.pop(context); // Close bottom sheet
      
      Navigator.of(context).pushReplacement(
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
    } catch (e) {
      debugPrint('Error navigating to individual chat: $e');
    }
  }

  Future<void> _forwardToCircle(String circleId) async {
    try {
      final repo = MyCircleRepository();
      final chats = await repo.fetchMyCircleChats();
      
      final circleChat = chats.firstWhere(
        (c) => c.id == circleId,
      );

      if (!mounted) return;

      final currentUserId = Supabase.instance.client.auth.currentUser!.id;
      final isAdmin = circleChat.adminId == currentUserId;

      Navigator.pop(context); // Close bottom sheet
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ChatBloc(repository: GroupChatRepository(Supabase.instance.client))
              ..add(LoadGroupMessages(chatId: circleChat.id))
              ..add(ForwardMessage(
                message: widget.message, 
                individualTargets: const [], 
                circleIds: [circleId], 
              )),
            child: MyCircleGroupChatPage(chat: circleChat, isAdmin: isAdmin),
          ),
        ),
      );
      
    } catch (e) {
      debugPrint('Could not find circle $circleId: $e');
    }
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
