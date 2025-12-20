import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/theme/texttheme/text_theme.dart';
import 'package:senior_circle/features/my_circle_home/models/circle_chat_model.dart';

class ChatListWidget extends StatelessWidget {
  final List<CircleChat> foundResults;
  final void Function(CircleChat) onChatTap;

  const ChatListWidget({
    super.key,
    required this.foundResults,
    required this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: foundResults.length,
      separatorBuilder: (context, index) => SizedBox(),
      itemBuilder: (context, index) {
        final chat = foundResults[index];
        return ListTile(
          shape: Border.all(color: AppColors.borderColor),
          tileColor: AppColors.white,
          leading: chat.isGroup
              ? CircleAvatar(
                  backgroundImage: NetworkImage(chat.imageUrl!),
                  radius: 26,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    chat.imageUrl!,
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
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.textDarkGray,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                chat.time as String,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  color: AppColors.dateColor,
                ),
              ),
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    final parts = chat.lastMessage?.split(': ');
                    final sender = parts!.length > 1 ? parts[0] : '';
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
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: isMe
                                    ? AppColors.textGray
                                    : AppColors.buttonBlue,
                              ),
                            ),
                          TextSpan(
                            text: message,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
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
          onTap: () => onChatTap(chat),
        );
      },
    );
  }
}
