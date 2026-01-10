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
  final Set<String> selectedIndividualIds = {};
  final Set<String> selectedCircleIds = {};
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
            id: '', // Dummy if not found, logic should handle missing conv
            name: friend.name,
            imageUrl: friend.profileImage,
            updatedAt: DateTime.now(),
            otherUserId: friend.id, createdAt: null,
          ),
        );

        if (conversation.id.isNotEmpty) {
          items.add(ForwardItem(
            id: conversation.id,
            name: friend.name,
            avatarUrl: friend.profileImage,
            isGroup: false,
            otherUserId: friend.id,
          ));
        }
      }

      if (mounted) {
        setState(() {
          allItems = items;
          filteredItems = items;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading targets for forward: $e');
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

  void _toggleSelection(ForwardItem item) {
    setState(() {
      final id = item.id;
      if (item.isGroup) {
        if (selectedCircleIds.contains(id)) {
          selectedCircleIds.remove(id);
        } else {
          selectedCircleIds.add(id);
        }
      } else {
        if (selectedIndividualIds.contains(id)) {
          selectedIndividualIds.remove(id);
        } else {
          selectedIndividualIds.add(id);
        }
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
    final totalSelected = selectedIndividualIds.length + selectedCircleIds.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const Text(
            'Forward',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          if (totalSelected > 0)
            Text(
              '$totalSelected selected',
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
        final isSelected = item.isGroup 
            ? selectedCircleIds.contains(item.id)
            : selectedIndividualIds.contains(item.id);

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
            onChanged: (_) => _toggleSelection(item),
          ),
          onTap: () => _toggleSelection(item),
        );
      },
    );
  }


  Future<void> _forward() async {
    final totalSelected = selectedIndividualIds.length + selectedCircleIds.length;
    if (totalSelected == 0) return;

    // SINGLE TARGET CASE
    if (totalSelected == 1) {
      if (selectedIndividualIds.length == 1) {
        final conversationId = selectedIndividualIds.first;
        await _forwardToIndividual(conversationId);
      } else {
        final circleId = selectedCircleIds.first;
        await _forwardToCircle(circleId);
      }
      return;
    }

    // MULTI TARGET CASE
    debugPrint('Forwarding message to ${selectedIndividualIds.length} conversations and ${selectedCircleIds.length} circles');

    context.read<ChatBloc>().add(
          ForwardMessage(
            message: widget.message,
            conversationIds: selectedIndividualIds.toList(),
            circleIds: selectedCircleIds.toList(),
          ),
        );

    // After Batch Forwarding, go back to My Circle (Home Page)
    if (mounted) {
      Navigator.pop(context); // Close bottom sheet
      Navigator.of(context).pop(); // Go back from current chatroom to Home
      _showSuccess('Message forwarded successfully');
    }
  }

  Future<void> _forwardToIndividual(String conversationId) async {
    try {
      final repo = MyCircleRepository();
      final chats = await repo.fetchMyCircleChats();
      
      final individualChat = chats.firstWhere(
        (c) => c.id == conversationId,
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
      debugPrint('Could not find existing conversation for $conversationId: $e');
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
                conversationIds: const [], 
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
