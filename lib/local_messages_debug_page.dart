import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/local_db/app_database.dart';
import 'package:senior_circle/core/local_db/daos/individual_messages_dao.dart';
import 'package:senior_circle/core/local_db/daos/message_reactions_dao.dart';

class LocalMessagesDebugPage extends StatelessWidget {
  const LocalMessagesDebugPage({super.key, required this.testConversationId});

  final String testConversationId;

  @override
  Widget build(BuildContext context) {
    final db = context.read<AppDatabase>();
    final messagesDao = IndividualMessagesDao(db);
    final reactionsDao = MessageReactionsDao(db);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Local DB Messages (Debug)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final data = await messagesDao
                  .watchMessages(testConversationId)
                  .first;
              debugPrint('LOCAL DB MESSAGE COUNT: ${data.length}');
            },
          ),
          IconButton(
            icon: const Icon(Icons.emoji_emotions),
            tooltip: 'Check Reactions',
            onPressed: () async {
              // Query all reactions directly from the table
              final allReactions = await (db.select(db.messageReactions)).get();
              debugPrint('🎭 TOTAL REACTIONS IN DB: ${allReactions.length}');
              for (final r in allReactions) {
                debugPrint(
                  '  - msgId: ${r.messageId}, reaction: ${r.reaction}, userId: ${r.userId}',
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: messagesDao.watchMessages(testConversationId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final messages = snapshot.data!;

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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.message),
                    title: Text(
                      msg.content.isNotEmpty ? msg.content : '[Media message]',
                    ),
                    subtitle: Text(
                      'ID: ${msg.id}\n'
                      'Sender: ${msg.senderId}\n'
                      'Created: ${msg.createdAt.toLocal()}',
                    ),
                  ),

                  /// 🔽 REACTIONS
                  Padding(
                    padding: const EdgeInsets.only(left: 56, bottom: 8),
                    child: StreamBuilder(
                      stream: reactionsDao.watchReactionsByMessageId(msg.id),
                      builder: (context, reactionSnap) {
                        debugPrint(
                          '🔍 Reactions for msg ${msg.id}: hasData=${reactionSnap.hasData}, data=${reactionSnap.data}',
                        );

                        if (!reactionSnap.hasData ||
                            reactionSnap.data!.isEmpty) {
                          debugPrint('❌ No reactions for msg ${msg.id}');
                          return const SizedBox();
                        }

                        final reactions = reactionSnap.data!;
                        debugPrint(
                          '✅ Found ${reactions.length} reactions for msg ${msg.id}',
                        );

                        /// group by emoji
                        final Map<String, int> grouped = {};
                        for (final r in reactions) {
                          debugPrint(
                            '   Reaction: ${r.reaction} by ${r.userId}',
                          );
                          grouped[r.reaction] = (grouped[r.reaction] ?? 0) + 1;
                        }

                        debugPrint('📊 Grouped reactions: $grouped');

                        return Wrap(
                          spacing: 6,
                          children: grouped.entries.map((e) {
                            return Chip(
                              label: Text('${e.key} ${e.value}'),
                              visualDensity: VisualDensity.compact,
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
