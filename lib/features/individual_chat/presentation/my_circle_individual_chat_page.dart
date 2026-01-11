import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/individual_chat/bloc/individual_chat_bloc.dart';
import 'package:senior_circle/features/individual_chat/presentation/widgets/individual_chat_room_appbar.dart';
import 'package:senior_circle/features/individual_chat/presentation/widgets/individual_message_card.dart';
import 'package:senior_circle/features/individual_chat/presentation/widgets/individual_message_input_field.dart';
import 'package:senior_circle/features/my_circle_home/models/my_circle_model.dart';

class MyCircleIndividualChatPage extends StatefulWidget {
  const MyCircleIndividualChatPage({super.key, required this.chat});

  final MyCircle chat;

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

    /// Load messages ONCE
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IndividualChatBloc>().add(
        LoadConversationMessages(widget.chat.id),
      );
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      if (_scrollController.position.maxScrollExtent <= 0) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyCircleIndividualAppBar(
        userName: widget.chat.name,
        profileUrl: widget.chat.imageUrl,
        userId: widget.chat.otherUserId ?? '',
      ),

      /// 🔥 GLOBAL LISTENER FOR SNACKBARS
      body: BlocListener<IndividualChatBloc, IndividualChatState>(
        listenWhen: (_, state) =>
            state is StarMessageSuccess ||
            state is StarMessageFailure ||
            state is DeleteMessageSuccess ||
            state is DeleteMessageFailure,
        listener: (context, state) {
          if (state is StarMessageSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state is StarMessageFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state is DeleteMessageSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state is DeleteMessageFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },

        /// 🔽 CHAT UI
        child: Container(
          decoration: BoxDecoration(gradient: AppColors.chatGradient),
          child: Column(
            children: [
              /// ================= CHAT LIST =================
              Expanded(
                child: BlocConsumer<IndividualChatBloc, IndividualChatState>(
                  /// ✅ REBUILD WHEN MESSAGE LIST CHANGES
                  buildWhen: (previous, current) {
                    if (previous is IndividualChatLoaded &&
                        current is IndividualChatLoaded) {
                      return previous.version != current.version;
                    }
                    return true;
                  },

                  /// ✅ SCROLL WHEN MESSAGE LIST CHANGES
                  listenWhen: (previous, current) {
                    if (previous is IndividualChatLoaded &&
                        current is IndividualChatLoaded) {
                      return previous.messages != current.messages;
                    }
                    return false;
                  },
                  listener: (context, state) {
                    _scrollToBottom();
                  },
                  builder: (context, state) {
                    if (state is IndividualChatLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is IndividualChatError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      );
                    }

                    if (state is IndividualChatLoaded) {
                      if (state.messages.isEmpty) {
                        return const Center(
                          child: Text(
                            "No messages yet",
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: state.messages.length,

                        /// Performance optimizations
                        addAutomaticKeepAlives: false,
                        addRepaintBoundaries: true,
                        cacheExtent: 500,

                        itemBuilder: (context, index) {
                          final message = state.messages[index];

                          return Dismissible(
                            key: ValueKey(message.id),
                            direction: DismissDirection.startToEnd,
                            confirmDismiss: (_) async {
                              context.read<IndividualChatBloc>().add(
                                PickReplyMessage(message),
                              );
                              return false;
                            },
                            background: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              child: const Icon(
                                Icons.reply,
                                color: Colors.grey,
                              ),
                            ),
                            child: IndividualMessageCard(message: message),
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),

              /// ================= INPUT FIELD =================
              BlocBuilder<IndividualChatBloc, IndividualChatState>(
                buildWhen: (previous, current) {
                  if (previous is IndividualChatLoaded &&
                      current is IndividualChatLoaded) {
                    return previous.isSending != current.isSending ||
                        previous.replyTo != current.replyTo;
                  }
                  return false;
                },
                builder: (context, state) {
                  return IndividualMessageInputField();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
