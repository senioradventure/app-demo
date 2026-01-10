import 'package:flutter/material.dart';

class MessageTime extends StatelessWidget {
  final DateTime dateTime;
  final bool isMe;

  const MessageTime({
    super.key,
    required this.dateTime,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';

    return Align(
      alignment: Alignment.bottomRight,
      child: Text(
        '$hour:$minute $period',
        style: TextStyle(
          fontSize: 11,
          color: isMe ? Colors.white70 : Colors.grey.shade600,
        ),
      ),
    );
  }
}
