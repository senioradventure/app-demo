import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/starred_messages/data/models/saved_message_model.dart';
import 'package:senior_circle/features/starred_messages/data/repositories/starred_messages_repository.dart';

class StarredMessagesPage extends StatefulWidget {
  const StarredMessagesPage({super.key});

  @override
  State<StarredMessagesPage> createState() => _StarredMessagesPageState();
}

class _StarredMessagesPageState extends State<StarredMessagesPage> {
  final StarredMessagesRepository _repository = StarredMessagesRepository();
  late Future<List<SavedMessage>> _starredMessagesFuture;

  @override
  void initState() {
    super.initState();
    _starredMessagesFuture = _repository.fetchStarredMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'Starred Messages',
          style: TextStyle(
            color: AppColors.textDarkGray,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.iconColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<SavedMessage>>(
        future: _starredMessagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No starred messages found.'));
          }

          final messages = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return _buildMessageItem(message);
            },
          );
        },
      ),
    );
  }

  Widget _buildMessageItem(SavedMessage message) {
    String sourceLabel = 'Chat';
    Color sourceColor = Colors.blue;

    if (message.sourceType == 'circle') {
      sourceLabel = 'Circles';
      sourceColor = Colors.green;
    } else if (message.sourceType == 'live chat') {
      sourceLabel = 'Live Chat';
      sourceColor = Colors.orange;
    } else if (message.sourceType == 'conversation') {
      sourceLabel = 'Individual';
      sourceColor = Colors.purple;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F0FF),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: AppColors.lightGray),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                message.senderName ?? 'User',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textDarkGray,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: sourceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  sourceLabel,
                  style: TextStyle(
                    color: sourceColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (message.mediaType == 'image' && message.mediaUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                message.mediaUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180,
                    color: AppColors.lightGray,
                    child: const Center(child: Icon(Icons.broken_image, size: 40)),
                  );
                },
              ),
            ),
            if (message.content != null && message.content!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                message.content!,
                style: const TextStyle(
                  color: AppColors.textDarkGray,
                  fontSize: 15.0,
                  height: 1.4,
                ),
              ),
            ],
          ] else if (message.content != null) ...[
            Text(
              message.content!,
              style: const TextStyle(
                color: AppColors.textDarkGray,
                fontSize: 15.0,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
