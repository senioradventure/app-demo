import 'package:flutter/material.dart';

class MessageFileBubble extends StatelessWidget {
  final String fileUrl;
  final bool isMe;

  const MessageFileBubble({
    super.key,
    required this.fileUrl,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final fileName = Uri.parse(fileUrl).pathSegments.last;

    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isMe ? Colors.blue.shade100 : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.insert_drive_file,
            size: 22,
            color: Colors.black87,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
