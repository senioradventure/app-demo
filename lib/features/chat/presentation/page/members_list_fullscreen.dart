import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/chat_details_models.dart';
import '../../repositories/chat_details_repository.dart';

class MembersListFullscreen extends StatefulWidget {
  final String chatId;
  final ChatType type;

  const MembersListFullscreen({
    super.key,
    required this.chatId,
    required this.type,
  });

  @override
  State<MembersListFullscreen> createState() => _MembersListFullscreenState();
}

class _MembersListFullscreenState extends State<MembersListFullscreen> {
  late ChatDetailsRepository _repository;
  List<ChatMember> _members = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = ChatDetailsRepository(Supabase.instance.client);
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    try {
      final members = await _repository.getChatMembers(
        widget.chatId,
        widget.type,
      );
      if (mounted) {
        setState(() {
          _members = members;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching members: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text('Members', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _members.isEmpty
          ? Center(
              child: Text(
                widget.type == ChatType.room ? 'No participants' : 'No members',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: _members
                    .map(
                      (member) => Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 22.0,
                            backgroundImage:
                                member.avatarUrl != null &&
                                    member.avatarUrl!.isNotEmpty
                                ? NetworkImage(member.avatarUrl!)
                                : const AssetImage('assets/images/avatar.png')
                                      as ImageProvider,
                          ),
                          title: Text(
                            member.name ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          trailing: member.isAdmin
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
                      ),
                    )
                    .toList(),
              ),
            ),
    );
  }
}
