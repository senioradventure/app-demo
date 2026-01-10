import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/core/utils/date_time_formatter.dart';
import 'package:senior_circle/features/my_circle_home/models/my_circle_model.dart';

class ChatListWidget extends StatelessWidget {
  final List<MyCircle> foundResults;
  final void Function(MyCircle) onChatTap;

  const ChatListWidget({
    super.key,
    required this.foundResults,
    required this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: foundResults.length,
      separatorBuilder: (context, index) =>
          Divider(height: 1, color: AppColors.borderColor),

      itemBuilder: (context, index) {
        final chat = foundResults[index];
        final bool hasImage =
            chat.imageUrl != null && chat.imageUrl!.isNotEmpty;

        return Material(
          color: AppColors.white,
          child: ListTile(
            
            leading: chat.isGroup
                ? CircleAvatar(
                    radius: 26,
                    backgroundImage: hasImage
                        ? NetworkImage(chat.imageUrl!)
                        : null,
                    backgroundColor: AppColors.borderColor,
                    child: hasImage ? null : const Icon(Icons.group),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: hasImage
                        ? Image.network(
                            chat.imageUrl!,
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 52,
                            height: 52,
                            color: AppColors.borderColor,
                            child: const Icon(Icons.person),
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
                  formatChatTime(context, chat.updatedAt!),
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
                // Expanded(
                //   child: Builder(
                //     builder: (context) {
                //       final lastMessage = chat.lastMessage ?? '';
                //       final parts = lastMessage.split(': ');
                //       final sender = parts.length > 1 ? parts[0] : '';
                //       final message = parts.length > 1 ? parts[1] : lastMessage;
                //       final isMe = sender.toLowerCase() == 'you';
          
                //       return RichText(
                //         text: TextSpan(
                //           children: [
                //             if (sender.isNotEmpty)
                //               TextSpan(
                //                 text: '$sender: ',
                //                 style: TextStyle(
                //                   fontWeight: FontWeight.w700,
                //                   fontSize: 14,
                //                   color: isMe
                //                       ? AppColors.textGray
                //                       : AppColors.buttonBlue,
                //                 ),
                //               ),
                //             TextSpan(
                //               text: message,
                //               style: TextStyle(
                //                 fontWeight: FontWeight.w500,
                //                 fontSize: 14,
                //                 color: chat.unreadCount > 0
                //                     ? AppColors.buttonBlue
                //                     : AppColors.textGray,
                //               ),
                //             ),
                //           ],
                //         ),
                //         maxLines: 1,
                //         overflow: TextOverflow.ellipsis,
                //       );
                //     },
                //   ),
                // ),
                // if (chat.unreadCount > 0) ...[
                //   SizedBox(width: 8),
                //   Container(
                //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                //     decoration: BoxDecoration(
                //       color: AppColors.buttonBlue,
                //       borderRadius: BorderRadius.circular(12),
                //     ),
                //     child: Text(
                //       chat.unreadCount.toString(),
                //       style: AppTextTheme.lightTextTheme.labelSmall?.copyWith(
                //         color: AppColors.white,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ],
              ],
            ),
            onTap: () => onChatTap(chat),
          ),
        );
      },
    );
  }
}
