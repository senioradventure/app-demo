import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'members_list_fullscreen.dart';
import '../../bloc/admin_reports_bloc.dart';
import '../../bloc/admin_reports_event.dart';
import '../../bloc/admin_reports_state.dart';
import '../../repositories/admin_reports_repository.dart';

class ChatDetailsScreenadmin extends StatefulWidget {
  final String liveChatRoomId;

  const ChatDetailsScreenadmin({super.key, required this.liveChatRoomId});

  @override
  State<ChatDetailsScreenadmin> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreenadmin> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AdminReportsBloc(AdminReportsRepository(Supabase.instance.client))
            ..add(LoadAdminReports(widget.liveChatRoomId)),
      child: Scaffold(
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
                          top: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 50.0,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                    const SizedBox(height: 16),
                    // Group Name
                    const Text(
                      'Chai Talks',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: const Text(
                          'Masala chai, the spiced milk tea widely loved in India today, was actually popularized only in the 20th century — after the British encouraged tea consumption in India to boost sales for their tea companies. Indians',
                          style: TextStyle(
                            color: Colors.black87,
                            height: 1.4,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),

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

                    // Reported messages
                    BlocBuilder<AdminReportsBloc, AdminReportsState>(
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
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 48,
                                  ),
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

                        final actionMessageId =
                            state is AdminReportActionInProgress
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
                                        backgroundImage:
                                            report.reportedUserAvatar != null
                                            ? NetworkImage(
                                                report.reportedUserAvatar!,
                                              )
                                            : const AssetImage(
                                                    'assets/images/avatar.png',
                                                  )
                                                  as ImageProvider,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text(
                                          report.reportedUserName ??
                                              'Unknown User',
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
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
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
                                      const Icon(
                                        Icons.flag,
                                        color: Colors.redAccent,
                                        size: 16,
                                      ),
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
                                                  context
                                                      .read<AdminReportsBloc>()
                                                      .add(
                                                        DismissAdminReport(
                                                          report
                                                              .reportedMessageId,
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
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(Colors.grey),
                                                    ),
                                                  )
                                                : const Text(
                                                    "DISMISS",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                            Color
                                                          >(Colors.white),
                                                    ),
                                                  )
                                                : const Text(
                                                    "DELETE",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                    ),
                    //End of reported messages
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
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade200,
                          width: 1,
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        radius: 22.0,
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                      ),
                      title: const Text(
                        'Chai Talks',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Container(
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
                      ),
                    ),
                  ),
                  ...List.generate(
                    4,
                    (index) => Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: const ListTile(
                        leading: CircleAvatar(
                          radius: 22.0,
                          backgroundImage: AssetImage(
                            'assets/images/avatar.png',
                          ),
                        ),
                        title: Text(
                          'Chai Talks',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
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
                            builder: (context) => const MembersListFullscreen(),
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
              ),
            ],
          ),
        ),
      ),
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
}
