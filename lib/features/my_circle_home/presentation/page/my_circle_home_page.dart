import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/chat/ui/circle_creation_screen.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/page/my_circle_group_chat_page.dart';
import 'package:senior_circle/features/my_circle_chatroom/presentation/page/my_circle_individual_chat_page.dart';
import 'package:senior_circle/features/my_circle_home/bloc/chat_bloc.dart';
import 'package:senior_circle/features/my_circle_home/bloc/chat_event.dart';
import 'package:senior_circle/features/my_circle_home/bloc/chat_state.dart';
import 'package:senior_circle/features/my_circle_home/models/circle_chat_model.dart';
import 'package:senior_circle/features/my_circle_home/presentation/widgets/my_circle_home_add_chat_widget.dart';
import 'package:senior_circle/features/my_circle_home/presentation/widgets/my_circle_home_chat_list_widget.dart';
import 'package:senior_circle/features/my_circle_home/presentation/widgets/my_circle_home_search_bar_widget.dart';
import 'package:senior_circle/features/my_circle_home/presentation/widgets/my_circle_home_starred_message_widget.dart';

class MyCircleHomePage extends StatefulWidget {
  const MyCircleHomePage({super.key});

  @override
  State<MyCircleHomePage> createState() => _MyCircleHomePageState();
}

class _MyCircleHomePageState extends State<MyCircleHomePage> {
  void navigateToChatRoom(CircleChat chat) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => chat.isGroup
            ? MyCircleGroupChatPage(chat: chat)
            : MyCircleIndividualChatPage(chat: chat),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.lightGray,
      appBar: AppBar(
        backgroundColor: AppColors.lightGray,
        title: Text(
          'My Circle',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 24,
            color: AppColors.textBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.iconColor),
      ),
      body: Column(
        children: [
          SearchBarWidget(
            onChanged: (value) {
              context.read<ChatBloc>().add(FilterChats(value));
            },
          ),
          SizedBox(height: 4),
          StarredMessageWidget(),
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ChatLoaded) {
                  return ChatListWidget(
                    foundResults: state.chats,
                    onChatTap: navigateToChatRoom,
                  );
                }

                if (state is ChatError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: AddChatWidget(
        destinationPage: const CircleCreationScreen(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}

