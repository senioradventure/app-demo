import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'members_list_fullscreen.dart';
import '../../bloc/admin_reports_bloc.dart';
import '../../bloc/admin_reports_event.dart';
import '../../bloc/admin_reports_state.dart';
import '../../repositories/admin_reports_repository.dart';
import '../../repositories/chat_details_repository.dart';
import '../../models/chat_details_models.dart';
import '../widgets/add_friends_bottom_sheet.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String chatId;
  final ChatType type;

  const ChatDetailsScreen({
    super.key,
    required this.chatId,
    required this.type,
  });

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  late ChatDetailsRepository _repository;
  ChatDetailsModel? _details;
  List<ChatMember> _members = [];
  bool _isLoading = true;
  bool _isAdmin = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _repository = ChatDetailsRepository(Supabase.instance.client);
    _currentUserId = Supabase.instance.client.auth.currentUser?.id;
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    try {
      final details = await _repository.getChatDetails(
        widget.chatId,
        widget.type,
      );
      final members = await _repository.getChatMembers(
        widget.chatId,
        widget.type,
      );

      // Determine if current user is admin
      // 1. Check if user is the creator/admin of the chat object
      bool isAdmin = details.adminId == _currentUserId;

      // 2. Or check if user has admin role in members list
      if (!isAdmin && _currentUserId != null) {
        final member = members.firstWhere(
          (m) => m.userId == _currentUserId,
          orElse: () => ChatMember(userId: '', role: ChatRole.member),
        );
        isAdmin = member.isAdmin;
      }

      if (mounted) {
        setState(() {
          _details = details;
          _members = members;
          _isAdmin = isAdmin;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching details: $e');
      if (mounted) {
        setState(() {
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

    if (_details == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text("Failed to load details")),
      );
    }

    Widget content = Scaffold(
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
            onPressed: () {},
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
                    backgroundImage:
                        _details!.imageUrl != null &&
                            _details!.imageUrl!.isNotEmpty
                        ? NetworkImage(_details!.imageUrl!)
                        : const AssetImage('assets/images/avatar.png')
                              as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  // Group Name
                  Text(
                    _details!.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tags/Categories
                  if (_details is RoomDetails) ...[
                    // Placeholder for tags if needed as per UI
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xd7d7e6fa),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Tea'),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xd7d7e6fa),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Tea'),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xd7d7e6fa),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('Friends'),
                          ),
                        ],
                      ),
                    ),

                    if ((_details as RoomDetails).description != null)
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
                            (_details as RoomDetails).description!,
                            style: const TextStyle(
                              color: Colors.black87,
                              height: 1.4,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                  ],

                  if (_isAdmin && widget.type == ChatType.room) ...[
                    //Reported messages section
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Reported Messages',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildReportedMessages(),
                  ],

                  // Members Section
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Members',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        if (widget.type == ChatType.circle)
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => AddFriendsBottomSheet(
                                  chatId: widget.chatId,
                                  currentMembers: _members,
                                  onMembersAdded: () {
                                    _fetchDetails(); // Refresh list after adding members
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Members added successfully',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.add_circle,
                              color: Colors.blue,
                              size: 28,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
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
            _buildMembersList(),
          ],
        ),
      ),
    );

    if (_isAdmin && widget.type == ChatType.room) {
      return BlocProvider(
        create: (context) =>
            AdminReportsBloc(AdminReportsRepository(Supabase.instance.client))
              ..add(LoadAdminReports(widget.chatId)),
        child: content,
      );
    }

    return content;
  }

  Widget _buildReportedMessages() {
    return BlocBuilder<AdminReportsBloc, AdminReportsState>(
      builder: (context, state) {
        if (state is AdminReportsLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is AdminReportsError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading reports',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final reports = state is AdminReportsLoaded
            ? state.reports
            : state is AdminReportActionInProgress
            ? state.reports
            : [];

        if (reports.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green.shade400,
                    size: 36,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No reported messages',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final actionMessageId = state is AdminReportActionInProgress
            ? state.actionMessageId
            : null;

        return Column(
          children: reports.map((report) {
            final isActionInProgress =
                actionMessageId == report.reportedMessageId;

            return Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: report.reportedUserAvatar != null
                            ? NetworkImage(report.reportedUserAvatar!)
                            : const AssetImage('assets/images/avatar.png')
                                  as ImageProvider,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          report.reportedUserName ?? 'Unknown User',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      report.messageContent ?? 'No content',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.flag, color: Colors.redAccent, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        "Reported by ${report.reportCount}",
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: isActionInProgress
                              ? null
                              : () {
                                  context.read<AdminReportsBloc>().add(
                                    DismissAdminReport(
                                      report.reportedMessageId,
                                    ),
                                  );
                                },
                          child: Container(
                            height: 45,
                            color: isActionInProgress
                                ? Colors.grey.shade100
                                : Colors.grey.shade200,
                            alignment: Alignment.center,
                            child: isActionInProgress
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.grey,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    "DISMISS",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: isActionInProgress
                              ? null
                              : () {
                                  _showDeleteConfirmation(
                                    context,
                                    report.reportedMessageId,
                                  );
                                },
                          child: Container(
                            height: 45,
                            color: isActionInProgress
                                ? const Color(0xFFFFB3B3)
                                : const Color(0xFFFF6B6B),
                            alignment: Alignment.center,
                            child: isActionInProgress
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    "DELETE",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String messageId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text(
          'Are you sure you want to delete this message? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AdminReportsBloc>().add(
                DeleteAdminReportedMessage(messageId),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    if (_members.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Text(
            widget.type == ChatType.room ? 'No participants' : 'No members',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    // Show first 5 members, then "See all"
    final displayMembers = _members.take(5).toList();

    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ...displayMembers.map(
          (member) => Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 22.0,
                backgroundImage:
                    member.avatarUrl != null && member.avatarUrl!.isNotEmpty
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
        ),

        if (_members.length > 5)
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 1),
              ),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MembersListFullscreen(
                      chatId: widget.chatId,
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
          ),
      ],
    );
  }
}
