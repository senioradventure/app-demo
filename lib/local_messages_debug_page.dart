import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/local_db/app_database.dart';
import 'package:senior_circle/core/local_db/daos/individual_messages_dao.dart';

class LocalMessagesDebugPage extends StatelessWidget {
  const LocalMessagesDebugPage({
    super.key,
    required this.testConversationId,
  });

  final String testConversationId;

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    final dao = IndividualMessagesDao(db);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local DB Messages (Debug)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final data = await dao.watchMessages(testConversationId).first;
              debugPrint('LOCAL DB MESSAGE COUNT: ${data.length}');
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: dao.watchMessages(testConversationId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final messages = snapshot.data ?? [];

          if (messages.isEmpty) {
            return const Center(
              child: Text(
                '❌ No messages found in local DB\n(for this conversation)',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            itemCount: messages.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final msg = messages[index];
              return ListTile(
                leading: const Icon(Icons.message),
                title: Text(
                  msg.content.isNotEmpty ? msg.content : '[Media message]',
                ),
                subtitle: Text(
                  'ID: ${msg.id}\n'
                  'Sender: ${msg.senderId}\n'
                  'Created: ${msg.createdAt.toLocal()}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
