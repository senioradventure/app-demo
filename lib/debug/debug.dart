import 'package:flutter/material.dart';
import 'package:senior_circle/features/live_chat_chat_room/data/local/database.dart';

class LocalDbMessagesDebugPage extends StatelessWidget {
  final AppDatabase db;
  final String roomId;

  const LocalDbMessagesDebugPage({
    super.key,
    required this.db,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local DB Messages (Debug)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // just rebuilds stream
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: db.messagesDao.watchMessages(roomId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final messages = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.green.shade50,
                child: Text(
                  '✅ ${messages.length} messages found in local DB',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: messages.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final m = messages[index];

                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.message, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Message',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            m.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          _kv('ID', m.id),
                          _kv('Sender', m.senderId),
                          _kv(
                            'Created',
                            m.createdAt.toString(),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Raw object:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            m.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _kv(String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        '$key: $value',
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}
