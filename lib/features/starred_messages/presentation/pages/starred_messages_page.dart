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
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.lightGray,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message.mediaType == 'image' && message.mediaUrl != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                message.mediaUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Icon(Icons.broken_image, size: 50)),
                  );
                },
              ),
            ),
            if (message.content != null && message.content!.isNotEmpty) ...[
              const SizedBox(height: 8.0),
              Text(
                message.content!,
                style: const TextStyle(
                  color: AppColors.textDarkGray,
                  fontSize: 16.0,
                ),
              ),
            ],
          ] else if (message.content != null) ...[
            Text(
              message.content!,
              style: const TextStyle(
                color: AppColors.textDarkGray,
                fontSize: 16.0,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
