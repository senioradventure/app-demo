import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'members_list_fullscreen.dart';

enum ChatType { room, circle }

class ChatDetailsScreen extends StatefulWidget {
  final String id;
  final ChatType type;

  const ChatDetailsScreen({super.key, required this.id, required this.type});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  Map<String, dynamic>? _details;
  List<Map<String, dynamic>> _members = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    try {
      if (widget.type == ChatType.room) {
        // Fetch Room Details
        final roomResponse = await _supabase
            .from('live_chat_rooms')
            .select()
            .eq('id', widget.id)
            .single();

        // Fetch Room Participants
        final participantsResponse = await _supabase
            .from('live_chat_participants')
            .select('*, profiles(*)')
            .eq('room_id', widget.id)
            .limit(5); // Limit for preview

        setState(() {
          _details = roomResponse;
          _members = List<Map<String, dynamic>>.from(participantsResponse);
          _isLoading = false;
        });
      } else {
        // Fetch Circle Details
        final circleResponse = await _supabase
            .from('circles')
            .select()
            .eq('id', widget.id)
            .single();

        // Fetch Circle Members
        final membersResponse = await _supabase
            .from('circle_members')
            .select('*, profiles(*)')
            .eq('circle_id', widget.id)
            .limit(5); // Limit for preview

        setState(() {
          _details = circleResponse;
          _members = List<Map<String, dynamic>>.from(membersResponse);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white),
        body: Center(child: Text('Error: $_errorMessage')),
      );
    }

    if (_details == null) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: Text('No details found')),
      );
    }

    final String name = _details!['name'] ?? 'Unknown';
    final String? imageUrl = _details!['image_url'];
    final String description = _details!['description'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 23.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              /*More details*/
            },
            icon: const Icon(Icons.more_vert, color: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade300, width: 1),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: imageUrl != null
                        ? NetworkImage(imageUrl)
                        : const AssetImage('assets/images/avatar.png')
                              as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  // Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description (Only for Rooms)
                  if (widget.type == ChatType.room && description.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: Text(
                          description,
                          style: const TextStyle(
                            color: Colors.black87,
                            height: 1.4,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Members',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 9,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _members.length + 1, // +1 for "See all"
              itemBuilder: (context, index) {
                if (index == _members.length) {
                  // "See all" button
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MembersListFullscreen(
                              id: widget.id,
                              type: widget.type,
                            ),
                          ),
                        );
                      },
                      child: const ListTile(
                        title: Text(
                          'See all',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }

                final member = _members[index];
                final profile = member['profiles'];
                final String memberName = profile != null
                    ? (profile['full_name'] ??
                          profile['username'] ??
                          'Unknown Member')
                    : 'Unknown Member';
                final String? memberImage = profile?['avatar_url'];
                final bool isAdmin =
                    member['role'] == 'admin' ||
                    (widget.type == ChatType.room &&
                        _details!['admin_id'] == member['user_id']);

                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                    ),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 22.0,
                      backgroundImage: memberImage != null
                          ? NetworkImage(memberImage)
                          : const AssetImage('assets/images/avatar.png')
                                as ImageProvider,
                    ),
                    title: Text(
                      memberName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    trailing: isAdmin
                        ? Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amberAccent.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Admin'),
                          )
                        : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
