import 'package:flutter/material.dart';

import '../enum/chat_type.dart';
import '../repository/chat_details_repository.dart';

class MembersListFullscreen extends StatefulWidget {
  final String id;
  final ChatType type;

  const MembersListFullscreen({
    super.key,
    required this.id,
    required this.type,
  });

  @override
  State<MembersListFullscreen> createState() => _MembersListFullscreenState();
}

class _MembersListFullscreenState extends State<MembersListFullscreen> {
  final _repository = ChatDetailsRepository();
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAllMembers();
  }

  Future<void> _fetchAllMembers() async {
    try {
      final members = await _repository.fetchAllMembers(
        id: widget.id,
        type: widget.type,
      );

      setState(() {
        _members = members;
        _isLoading = false;
      });
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
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white),
        body: Center(child: Text('Error: $_errorMessage')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text('Members', style: TextStyle(color: Colors.black)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _members.length,
                itemBuilder: (context, index) {
                  final member = _members[index];
                  final profile = member['profiles'];
                  final String memberName = profile != null
                      ? (profile['full_name'] ??
                            profile['username'] ??
                            'Unknown Member')
                      : 'Unknown Member';
                  final String? memberImage = profile?['avatar_url'];

                  // For simplicity, checking 'role' in member/participant table if available, or just mocking admin for now if logic is complex
                  // In circles: role is in circle_members. In rooms: admin is in room details usually, but participants might not have role column.
                  // Assuming basic display for now.
                  final bool isAdmin = member['role'] == 'admin';

                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200, width: 1),
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
            ),
    );
  }
}
