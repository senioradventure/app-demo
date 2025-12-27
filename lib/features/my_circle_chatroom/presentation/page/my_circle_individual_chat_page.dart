import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_bloc.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_event.dart';
import 'package:senior_circle/features/my_circle_chatroom/bloc/chat_state.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_individual_message_card.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/message_input_field.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/widgets/my_circle_chatroom_app_bar.dart';
import 'package:senior_circle/features/my_circle_home/models/circle_chat_model.dart';

class MyCircleIndividualChatPage extends StatefulWidget {
  const MyCircleIndividualChatPage({super.key, required this.chat});

  final CircleChat chat;

  @override
  State<MyCircleIndividualChatPage> createState() =>
      _MyCircleIndividualChatPageState();
}

class _MyCircleIndividualChatPageState
    extends State<MyCircleIndividualChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessages());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCircleChatroomAppBar(chat: widget.chat,isAdmin: false),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.chatGradient),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      return IndividualMessageCard(
                        message: state.messages[index],
                      );
                    },
                  );
                },
              ),
            ),

            MessageInputField(
              onSend: (text, imagePath) {
                context.read<ChatBloc>().add(
                  SendMessage(text: text, imagePath: imagePath),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
