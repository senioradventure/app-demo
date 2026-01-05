import 'package:flutter/material.dart';

class MessageReactionRow extends StatelessWidget {
  final Map<String, int> reactions;
  final bool isMe;

  const MessageReactionRow({
    super.key,
    required this.reactions,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      children: reactions.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue.shade100 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Text(
            '${entry.key} ${entry.value}',
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
    );
  }
}
