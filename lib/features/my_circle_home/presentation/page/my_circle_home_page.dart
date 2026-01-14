import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/common/widgets/profile_aware_appbar.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/createCircle/presentation/circle_creation_screen.dart';
import 'package:senior_circle/features/circle_chat/presentation/page/circle_chat_page.dart';
import 'package:senior_circle/features/individual_chat/presentation/my_circle_individual_chat_page.dart';
import 'package:senior_circle/features/my_circle_home/bloc/my_circle_bloc.dart';
import 'package:senior_circle/features/my_circle_home/bloc/my_circle_event.dart';
import 'package:senior_circle/features/my_circle_home/bloc/my_circle_state.dart';
import 'package:senior_circle/features/my_circle_home/models/my_circle_model.dart';
import 'package:senior_circle/features/my_circle_home/presentation/widgets/my_circle_home_add_chat_widget.dart';
import 'package:senior_circle/features/my_circle_home/presentation/widgets/my_circle_home_chat_list_widget.dart';
import 'package:senior_circle/core/common/widgets/search_bar_widget.dart';
import 'package:senior_circle/features/my_circle_home/presentation/widgets/my_circle_home_starred_message_widget.dart';

class MyCircleHomePage extends StatefulWidget {
  const MyCircleHomePage({super.key});

  @override
  State<MyCircleHomePage> createState() => _MyCircleHomePageState();
}

class _MyCircleHomePageState extends State<MyCircleHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void deactivate() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.deactivate();
  }

  void navigateToChatRoom(MyCircle chat) {
    final currentUserId = context.read<MyCircleBloc>().repository.currentUserId;
    final isAdmin = chat.adminId == currentUserId;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          if (chat.isGroup) {
            return CircleChatPage(chat: chat, isAdmin: isAdmin);
          } else {
            return MyCircleIndividualChatPage(chat: chat);
          }
        },
      ),
    ).then((_) {
      if (mounted) {
        context.read<MyCircleBloc>().add(LoadMyCircleChats());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.lightGray,
      appBar: ProfileAwareAppBar(title: 'My Circle'),
      body: Column(
        children: [
          SearchBarWidget(
            onChanged: (value) {
              context.read<MyCircleBloc>().add(FilterMyCircleChats(value));
            },
          ),
          SizedBox(height: 4),
          StarredMessageWidget(),
          Expanded(
            child: BlocBuilder<MyCircleBloc, MyCircleState>(
              builder: (context, state) {
                if (state is MyCircleChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is MyCircleChatLoaded) {
                  return ChatListWidget(
                    foundResults: state.chats,
                    onChatTap: navigateToChatRoom,
                  );
                }
                if (state is MyCircleChatError) {
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
        onReturn: () {
          context.read<MyCircleBloc>().add(LoadMyCircleChats());
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
}
