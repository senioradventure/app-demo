import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_bloc.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_event.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_state.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/message_input_field.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_app_bar.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_card.dart';
import 'package:senior_circle/features/my_circle_home/models/circle_chat_model.dart';

class MyCircleGroupChatPage extends StatefulWidget {
  const MyCircleGroupChatPage({super.key, required this.chat,required this.isAdmin });
  final CircleChat chat;
  final bool isAdmin;

  @override
  State<MyCircleGroupChatPage> createState() => _MyCircleGroupChatPageState();
}

class _MyCircleGroupChatPageState extends State<MyCircleGroupChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadGroupMessages(chatId: widget.chat.id));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: MyCircleChatroomAppBar(chat: widget.chat,isAdmin: widget.isAdmin,),
      body: Column(
        children: [
          Expanded(
            child: BlocSelector<ChatBloc, ChatState, List<GroupMessage>>(
              selector: (state) => state.groupMessages,
              builder: (context, messages) {
                if (messages.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final currentMsg = messages[index];
                    final isContinuation =
                        index > 0 &&
                        messages[index - 1].senderName == currentMsg.senderName;

                    final isLastInGroup =
                        index == messages.length - 1 ||
                        messages[index + 1].senderName != currentMsg.senderName;

                    return GroupMessageCard(
                      key: ValueKey(currentMsg.id),
                      grpmessage: currentMsg,
                      isContinuation: isContinuation,
                      isLastInGroup: isLastInGroup,
                    );
                  },
                );
              },
            ),
          ),
          MessageInputField(
            onSend: (text, imagePath) {
              context.read<ChatBloc>().add(
                SendGroupMessage(text: text, imagePath: imagePath),
              );
            },
          ),
        ],
      ),
    );
  }
}
