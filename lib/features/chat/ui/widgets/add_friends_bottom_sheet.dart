import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:senior_circle/features/createCircle/model/friend_model.dart';
import 'dart:developer';

class AddFriendsBottomSheet extends StatefulWidget {
  final String circleId;
  final List<String> existingMemberIds;

  const AddFriendsBottomSheet({
    super.key,
    required this.circleId,
    required this.existingMemberIds,
  });

  @override
  State<AddFriendsBottomSheet> createState() => _AddFriendsBottomSheetState();
}

class _AddFriendsBottomSheetState extends State<AddFriendsBottomSheet> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  bool _isAdding = false;
  List<Friend> _allFriends = [];
  List<Friend> _filteredFriends = [];
  final Set<String> _selectedFriendIds = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchFriends();
  }

  Future<void> _fetchFriends() async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final data = await _supabase.rpc(
        'get_friends',
        params: {'user_id': userId},
      );

      final List<dynamic> responseList = data as List<dynamic>;
      final friends = responseList
          .map((json) => Friend.fromJson(json))
          .toList();

      // Filter out existing members
      final newFriends = friends
          .where((friend) => !widget.existingMemberIds.contains(friend.id))
          .toList();

      if (mounted) {
        setState(() {
          _allFriends = newFriends;
          _filteredFriends = newFriends;
          _isLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching friends: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to load friends')));
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
        return friend.fullName.toLowerCase().contains(lowerQuery) ||
            friend.username.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  Future<void> _addSelectedFriends() async {
    if (_selectedFriendIds.isEmpty) return;

    setState(() {
      _isAdding = true;
    });

    try {
      final List<Map<String, dynamic>> membersPayload = [];
      for (final friendId in _selectedFriendIds) {
        membersPayload.add({
          'circle_id': widget.circleId,
          'user_id': friendId,
          'role': 'member',
          'joined_at': DateTime.now().toIso8601String(),
        });
      }

      await _supabase.from('circle_members').insert(membersPayload);

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      log('Error adding members: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to add members: $e')));
        setState(() {
          _isAdding = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Friends (${_selectedFriendIds.length})",
                  style: const TextStyle(
                    fontSize:
                        18, // Slightly larger to match screenshot style if needed
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: _filterFriends,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Search for friends",
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.grey.shade200),

          // List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredFriends.isEmpty
                ? const Center(
                    child: Text(
                      "No friends to add",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredFriends.length,
                    itemBuilder: (context, index) {
                      final friend = _filteredFriends[index];
                      final isSelected = _selectedFriendIds.contains(friend.id);

                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.grey.shade100,
                              width: 1,
                            ),
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedFriendIds.remove(friend.id);
                              } else {
                                _selectedFriendIds.add(friend.id);
                              }
                            });
                          },
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          leading: Transform.scale(
                            scale: 1.1,
                            child: Checkbox(
                              value: isSelected,
                              activeColor: Colors.blue,
                              shape:
                                  const CircleBorder(), // Making checkbox roundish if desired, or default
                              // Screenshot shows roundish selection or standard checkbox.
                              // Actually screenshot shows standard square checkbox logic but maybe round style?
                              // Let's stick to standard or match `CircleCreationScreen` which uses default Checkbox.
                              // Wait, screenshot 1 shows Circle checkboxes (radio style or custom checkbox)?
                              // Screenshot 1 uses blue filled circle with check or empty circle.
                              // Standard Checkbox is square. `CircleCreationScreen` uses standard Checkbox.
                              // I'll check `CircleCreationScreen` again.
                              // It uses `Checkbox` widget, which is square by default on Material 2/3 unless themed.
                              // Screenshot 1 shows blue circle. Maybe `shape: CircleBorder()`?
                              // Or maybe it's `Radio` style but for multiple selection.
                              // I'll use `shape: CircleBorder()` to match the likely intent of "circle" or modern look,
                              // or just keep default if unsure. Screenshot 1 clearly shows circles.
                              // Wait, let me check the screenshot again.
                              // They look like blue circles when selected, grey circles when not.
                              // Standard Checkbox with `shape: CircleBorder()` handles this well.
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedFriendIds.add(friend.id);
                                  } else {
                                    _selectedFriendIds.remove(friend.id);
                                  }
                                });
                              },
                            ),
                          ),
                          title: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: friend.avatarUrl != null
                                    ? NetworkImage(friend.avatarUrl!)
                                    : const AssetImage(
                                            'assets/images/avatar.png',
                                          )
                                          as ImageProvider,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  friend.fullName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
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

          // ADD Button
          if (!_isLoading)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    // Using ElevatedButton for the blue button
                    onPressed: _isAdding || _selectedFriendIds.isEmpty
                        ? null
                        : _addSelectedFriends,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF3B82F6,
                      ), // Blue color from screenshot approx
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          25,
                        ), // Rounded corners
                      ),
                      elevation: 0,
                    ),
                    child: _isAdding
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add, size: 24),
                              SizedBox(width: 8),
                              Text(
                                "ADD",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
