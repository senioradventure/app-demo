import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:senior_circle/features/view_friends/models/friends_model.dart';
import '../../repositories/chat_details_repository.dart';
import '../../models/chat_details_models.dart';

class AddFriendsBottomSheet extends StatefulWidget {
  final String chatId;
  final List<ChatMember> currentMembers;
  final Function() onMembersAdded;

  const AddFriendsBottomSheet({
    super.key,
    required this.chatId,
    required this.currentMembers,
    required this.onMembersAdded,
  });

  @override
  State<AddFriendsBottomSheet> createState() => _AddFriendsBottomSheetState();
}

class _AddFriendsBottomSheetState extends State<AddFriendsBottomSheet> {
  late ChatDetailsRepository _repository;
  List<Friend> _allFriends = [];
  List<Friend> _filteredFriends = [];
  final Set<String> _selectedFriendIds = {};
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repository = ChatDetailsRepository(Supabase.instance.client);
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final friends = await _repository.getFriends(userId);

      // Filter out friends who are already members
      final currentMemberIds = widget.currentMembers
          .map((m) => m.userId)
          .toSet();
      final potentialMembers = friends
          .where((f) => !currentMemberIds.contains(f.id))
          .toList();

      if (mounted) {
        setState(() {
          _allFriends = potentialMembers;
          _filteredFriends = potentialMembers;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching friends: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterFriends(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredFriends = _allFriends;
      });
      return;
    }

    final lowerQuery = query.toLowerCase();
    setState(() {
      _filteredFriends = _allFriends.where((friend) {
        return friend.name.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  Future<void> _addSelectedMembers() async {
    if (_selectedFriendIds.isEmpty) return;

    try {
      await _repository.addMembersToCircle(
        widget.chatId,
        _selectedFriendIds.toList(),
      );
      if (mounted) {
        Navigator.pop(context);
        widget.onMembersAdded();
      }
    } catch (e) {
      debugPrint('Error adding members: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to add members')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          // Handle bar
          // const SizedBox(height: 12),
          // Container(
          //   width: 40,
          //   height: 4,
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade300,
          //     borderRadius: BorderRadius.circular(2),
          //   ),
          // ),
          const SizedBox(height: 20),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Add Friends (${_allFriends.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Search Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: _filterFriends,
              decoration: InputDecoration(
                hintText: 'Search for friends',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredFriends.isEmpty
                ? const Center(
                    child: Text(
                      'No friends found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredFriends.length,
                    itemBuilder: (context, index) {
                      final friend = _filteredFriends[index];
                      final isSelected = _selectedFriendIds.contains(friend.id);

                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedFriendIds.remove(friend.id);
                            } else {
                              _selectedFriendIds.add(friend.id);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade100,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              // Custom Checkbox
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isSelected
                                      ? Colors.blue
                                      : Colors.grey.shade200,
                                  border: isSelected
                                      ? null
                                      : Border.all(color: Colors.grey.shade300),
                                ),
                                child: isSelected
                                    ? const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 16),

                              // Avatar
                              CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    friend.profileImage != null &&
                                        friend.profileImage!.isNotEmpty
                                    ? NetworkImage(friend.profileImage!)
                                    : const AssetImage(
                                            'assets/images/avatar.png',
                                          )
                                          as ImageProvider,
                              ),
                              const SizedBox(width: 16),

                              // Name
                              Expanded(
                                child: Text(
                                  friend.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Add Button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _selectedFriendIds.isNotEmpty
                    ? _addSelectedMembers
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: Colors.blue.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text(
                      'ADD',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
