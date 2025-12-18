import 'package:flutter/material.dart';
import 'package:senior_circle/core/constants/inividual_messages.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/my_circle_chatroom/models/message_model.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_individual_message_card.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/message_input_field.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_app_bar.dart';
import 'package:senior_circle/features/my_circle_home/models/chat_model.dart';

class MyCircleIndividualChatPage extends StatefulWidget {
  const MyCircleIndividualChatPage({super.key, required this.chat});

  final Chat chat;

  @override
  State<MyCircleIndividualChatPage> createState() => _MyCircleIndividualChatPageState();
}

class _MyCircleIndividualChatPageState extends State<MyCircleIndividualChatPage> {

  late List<Message> _messages;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
   
    _messages = rawMessageData
        .map((data) => Message.fromMap(data))
        .toList();
  }

  void _handleSendMessage(String text) {
    if (text.trim().isEmpty) return;

    final newMessageData = {
      'id' : '',
      'text': text,
      'time': TimeOfDay.now().format(context),
      'sender': 'You',
    };

    setState(() {
      _messages.add(Message.fromMap(newMessageData));
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCircleChatroomAppBar(chat: widget.chat),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.chatGradient),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return IndividualMessageCard(
                    message: _messages[index],
                    onAction: (action, msg) {
                      if (action.contains('DELETE')) {
                        setState(() => _messages.remove(msg));
                      }
                    },
                  );
                },
              ),
            ),
            MessageInputField(onSend: _handleSendMessage),
          ],
        ),
      ),
    );
  }
}