import 'package:flutter/material.dart';
import 'package:senior_circle/theme/colors/app_colors.dart';
import 'package:senior_circle/theme/texttheme/text_theme.dart';

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
  final List<Chat> foundResults;

  const ChatListWidget({super.key, required this.foundResults});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: foundResults.length,
      separatorBuilder: (context, index) => SizedBox(),
      itemBuilder: (context, index) {
        final chat = foundResults[index];
        return ListTile(
          tileColor: AppColors.white,
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
                  style: AppTextTheme.lightTextTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                chat.time,
                style: AppTextTheme.lightTextTheme.labelSmall?.copyWith(
                  color: AppColors.textGray,
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
                    final message = parts.length > 1
                        ? parts[1]
                        : chat.lastMessage;
                    final isMe = sender.toLowerCase() == 'you';
                    return RichText(
                      text: TextSpan(
                        children: [
                          if (sender.isNotEmpty)
                            TextSpan(
                              text: '$sender: ',
                              style: AppTextTheme.lightTextTheme.labelMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: isMe
                                        ? AppColors.textGray
                                        : AppColors.buttonBlue,
                                  ),
                            ),
                          TextSpan(
                            text: message,
                            style: AppTextTheme.lightTextTheme.labelMedium
                                ?.copyWith(
                                  color: chat.unreadCount > 0
                                      ? AppColors.buttonBlue
                                      : AppColors.textGray,
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
                    color: AppColors.buttonBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    chat.unreadCount.toString(),
                    style: AppTextTheme.lightTextTheme.labelSmall?.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          onTap: () {},
        );
      },
    );
  }
}
