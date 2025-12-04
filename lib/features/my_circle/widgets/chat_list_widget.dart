import 'package:flutter/material.dart';

class Chat {
  final String name;
  final String lastMessage;
  final String imageUrl;
  final bool isGroup;
  final String time;
  final int unreadCount;

  Chat({
    required this.name,
    required this.lastMessage,
    required this.imageUrl,
    required this.isGroup,
    required this.time,
    this.unreadCount = 0,
  });
}

class ChatListWidget extends StatelessWidget {
  final List<Chat> chats;

  const ChatListWidget({super.key, required this.chats});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: chats.length,
      separatorBuilder: (context, index) => SizedBox(),
      itemBuilder: (context, index) {
        final chat = chats[index];
        return ListTile(
          tileColor: Colors.white,
          leading: chat.isGroup
              ? CircleAvatar(
                  backgroundImage: AssetImage(chat.imageUrl),
                  radius: 26,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    chat.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  chat.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                chat.time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    final parts = chat.lastMessage.split(': ');
                    final sender = parts.length > 1 ? parts[0] : '';
                    final message = parts.length > 1 ? parts[1] : chat.lastMessage;
                    final isMe = sender.toLowerCase() == 'you' || sender.toLowerCase() == 'me';
                    return RichText(
                      text: TextSpan(
                        children: [
                          if (sender.isNotEmpty)
                            TextSpan(
                              text: '$sender: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isMe ?  Colors.black : Color(0xFF4A90E2),
                              ),
                            ),
                          TextSpan(
                            text: message,
                            style: TextStyle(
                              color: chat.unreadCount > 0 ? Color(0xFF4A90E2) : Colors.black,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ),
              if (chat.unreadCount > 0) ...[
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFF4A90E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    chat.unreadCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          onTap: () {
            // Handle chat tap
          },
        );
      },
    );
  }
}
