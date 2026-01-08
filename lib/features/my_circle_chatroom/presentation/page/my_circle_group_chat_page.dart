import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_bloc.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_event.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_state.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/group_message_model.dart';
import 'package:senior_circle/core/common/widgets/message_input_field.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_app_bar.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_grp_message_card.dart';
import 'package:senior_circle/features/my_circle_home/models/my_circle_model.dart';

class MyCircleGroupChatPage extends StatefulWidget {
  const MyCircleGroupChatPage({
    super.key,
    required this.chat,
    required this.isAdmin,
  });
  final MyCircle chat;
  final bool isAdmin;

  @override
  State<MyCircleGroupChatPage> createState() => _MyCircleGroupChatPageState();
}

class _MyCircleGroupChatPageState extends State<MyCircleGroupChatPage> {
  final ScrollController _scrollController = ScrollController();
  bool _initialScrollDone = false;

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

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: MyCircleChatroomAppBar(
        chat: widget.chat,
        isAdmin: widget.isAdmin,
      ),
      body: Column(
        children: [
          BlocListener<ChatBloc, ChatState>(
            listenWhen: (previous, current) =>
                previous.groupMessages.length != current.groupMessages.length,
            listener: (context, state) {
              if (state.groupMessages.isEmpty) return;

              // ✅ Scroll once when page opens
              if (!_initialScrollDone) {
                _initialScrollDone = true;
                _scrollToBottom();
                return;
              }

              // ✅ Scroll on new messages
              _scrollToBottom();
            },
            child: Expanded(
              child: BlocSelector<ChatBloc, ChatState, List<GroupMessage>>(
                selector: (state) => state.groupMessages,
                builder: (context, messages) {
                  if (messages.isEmpty) {
                    return const Center(child: Text('No messages yet'));
                  }
                  return ListView.builder(
                    reverse: true,
                    padding: EdgeInsets.zero,
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final currentMsg = messages[index];
                      final prevMsg = index < messages.length - 1 ? messages[index + 1] : null;
                      final nextMsg = index > 0 ? messages[index - 1] : null;

                      final isContinuation = prevMsg != null && prevMsg.senderId == currentMsg.senderId;

                      final isLastInGroup = nextMsg == null || nextMsg.senderId != currentMsg.senderId;

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
          ),
          MessageInputField(
            onSend: (text, imagePath) {
              context.read<ChatBloc>().add(
                SendGroupMessage(
                  text: text,
                  imagePath: imagePath,
                  circleId: widget.chat.id,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
