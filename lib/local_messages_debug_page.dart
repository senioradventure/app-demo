import 'dart:io';
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
            padding: const EdgeInsets.all(8),
            itemCount: messages.length,
            separatorBuilder: (_, __) => const Divider(thickness: 2),
            itemBuilder: (context, index) {
              final msg = messages[index];

              return _MessageDebugCard(
                message: msg,
                reactionsDao: reactionsDao,
              );
            },
          );
        },
      ),
    );
  }
}

class _MessageDebugCard extends StatefulWidget {
  const _MessageDebugCard({required this.message, required this.reactionsDao});

  final IndividualMessage message;
  final MessageReactionsDao reactionsDao;

  @override
  State<_MessageDebugCard> createState() => _MessageDebugCardState();
}

class _MessageDebugCardState extends State<_MessageDebugCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final msg = widget.message;
    final hasMedia = msg.mediaUrl != null || msg.localMediaPath != null;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: Icon(
              _getMediaIcon(msg.mediaType),
              color: _getMediaColor(msg.mediaType),
            ),
            title: Text(
              msg.content.isNotEmpty
                  ? msg.content
                  : '[${msg.mediaType} message]',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Type: ${msg.mediaType}\n'
              'Created: ${msg.createdAt.toLocal().toString().substring(0, 19)}',
            ),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),

          // Media Preview (if exists)
          if (hasMedia) _buildMediaPreview(msg),

          // Expanded Details
          if (_isExpanded) _buildExpandedDetails(msg),

          // Reactions
          _buildReactions(msg),
        ],
      ),
    );
  }

  Widget _buildMediaPreview(IndividualMessage msg) {
    final localPath = msg.localMediaPath;
    final hasLocalFile = localPath != null && File(localPath).existsSync();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasLocalFile ? Icons.check_circle : Icons.cloud,
                color: hasLocalFile ? Colors.green : Colors.blue,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                hasLocalFile ? 'Local File Available' : 'Remote Only',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: hasLocalFile ? Colors.green : Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Display media based on type
          if (msg.mediaType == 'image' && hasLocalFile)
            _buildImagePreview(localPath!)
          else if (msg.mediaType == 'image' && msg.mediaUrl != null)
            _buildRemoteImagePreview(msg.mediaUrl!)
          else if (msg.mediaType == 'audio' || msg.mediaType == 'voice')
            _buildAudioInfo(localPath, msg.mediaUrl)
          else if (msg.mediaType == 'file')
            _buildFileInfo(localPath, msg.mediaUrl),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String localPath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📷 Image Preview:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(localPath),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 100,
                color: Colors.red[100],
                child: const Center(child: Text('❌ Error loading image')),
              );
            },
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Path: $localPath',
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildRemoteImagePreview(String url) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🌐 Remote Image:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            url,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: 200,
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 100,
                color: Colors.red[100],
                child: const Center(
                  child: Text('❌ Error loading remote image'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAudioInfo(String? localPath, String? remoteUrl) {
    final hasLocal = localPath != null && File(localPath).existsSync();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎵 Audio File:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (hasLocal) ...[
          Row(
            children: [
              const Icon(Icons.audiotrack, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Local: ${localPath.split('/').last}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          Text(
            'Size: ${_getFileSize(localPath)}',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
        if (remoteUrl != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.cloud, color: Colors.blue, size: 16),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Remote URL available',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFileInfo(String? localPath, String? remoteUrl) {
    final hasLocal = localPath != null && File(localPath).existsSync();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📎 File Attachment:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (hasLocal) ...[
          Row(
            children: [
              const Icon(Icons.insert_drive_file, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  localPath.split('/').last,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          Text(
            'Size: ${_getFileSize(localPath)}',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
        if (remoteUrl != null) ...[
          const SizedBox(height: 4),
          const Row(
            children: [
              Icon(Icons.cloud, color: Colors.blue, size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Remote URL available',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildExpandedDetails(IndividualMessage msg) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📋 Full Message Data',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(),
          _buildDetailRow('ID', msg.id),
          _buildDetailRow('Sender ID', msg.senderId),
          _buildDetailRow(
            'Content',
            msg.content.isEmpty ? '(empty)' : msg.content,
          ),
          _buildDetailRow('Media Type', msg.mediaType),
          _buildDetailRow('Media URL', msg.mediaUrl ?? '(none)'),
          _buildDetailRow('Local Path', msg.localMediaPath ?? '(none)'),
          _buildDetailRow('Conversation ID', msg.conversationId),
          _buildDetailRow('Reply To', msg.replyToMessageId ?? '(none)'),
          _buildDetailRow(
            'Forwarded From',
            msg.forwardedFromMessageId ?? '(none)',
          ),
          _buildDetailRow('Created At', msg.createdAt.toLocal().toString()),
          _buildDetailRow(
            'Updated At',
            msg.updatedAt?.toLocal().toString() ?? '(none)',
          ),
          _buildDetailRow(
            'Expires At',
            msg.expiresAt?.toLocal().toString() ?? '(none)',
          ),
          _buildDetailRow(
            'Deleted At',
            msg.deletedAt?.toLocal().toString() ?? '(none)',
          ),

          // File existence check
          if (msg.localMediaPath != null) ...[
            const Divider(),
            _buildDetailRow(
              'Local File Exists',
              File(msg.localMediaPath!).existsSync() ? '✅ YES' : '❌ NO',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          Expanded(
            child: SelectableText(value, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildReactions(IndividualMessage msg) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: StreamBuilder(
        stream: widget.reactionsDao.watchReactionsByMessageId(msg.id),
        builder: (context, reactionSnap) {
          if (!reactionSnap.hasData || reactionSnap.data!.isEmpty) {
            return const SizedBox();
          }

          final reactions = reactionSnap.data!;

          // Group by emoji
          final Map<String, int> grouped = {};
          for (final r in reactions) {
            grouped[r.reaction] = (grouped[r.reaction] ?? 0) + 1;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '� Reactions:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                children: grouped.entries.map((e) {
                  return Chip(
                    label: Text('${e.key} ${e.value}'),
                    visualDensity: VisualDensity.compact,
                    backgroundColor: Colors.amber[100],
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  IconData _getMediaIcon(String mediaType) {
    switch (mediaType.toLowerCase()) {
      case 'image':
        return Icons.image;
      case 'audio':
      case 'voice':
        return Icons.audiotrack;
      case 'file':
        return Icons.insert_drive_file;
      case 'video':
        return Icons.videocam;
      default:
        return Icons.message;
    }
  }

  Color _getMediaColor(String mediaType) {
    switch (mediaType.toLowerCase()) {
      case 'image':
        return Colors.blue;
      case 'audio':
      case 'voice':
        return Colors.purple;
      case 'file':
        return Colors.orange;
      case 'video':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getFileSize(String path) {
    try {
      final file = File(path);
      if (!file.existsSync()) return 'N/A';

      final bytes = file.lengthSync();
      if (bytes < 1024) return '$bytes B';
      if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } catch (e) {
      return 'Error';
    }
  }
}
