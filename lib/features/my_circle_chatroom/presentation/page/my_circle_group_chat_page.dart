import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_bloc.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_event.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_state.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/message_input_field.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_app_bar.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_card.dart';
import 'package:senior_circle/features/my_circle_home/models/circle_chat_model.dart';

class MyCircleGroupChatPage extends StatefulWidget {
  const MyCircleGroupChatPage({super.key, required this.chat});
  final CircleChat chat;

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
      backgroundColor: AppColors.backgroundColor,
      appBar: MyCircleChatroomAppBar(chat: widget.chat),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = state.groupMessages;
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final currentMsg = messages[index];
                    final isContinuation =
                        index > 0 &&
                        messages[index - 1].senderName == currentMsg.senderName;
                    return GroupMessageCard(
                      key: ValueKey(currentMsg.id),
                      grpmessage: currentMsg,
                      isContinuation: isContinuation,
                    );
                  },
                );
              },
            ),
          ),
         MessageInputField(
  onSend: (text, imagePath) {
    context.read<ChatBloc>().add(
      SendGroupMessage(
        text: text,
        imagePath: imagePath,
      ),
    );
  },
),
        ],
      ),
    );
  }
}
