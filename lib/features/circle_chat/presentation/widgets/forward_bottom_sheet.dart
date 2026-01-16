import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/common/widgets/bottom_button.dart';
import 'package:senior_circle/core/common/widgets/search_bar_widget.dart';
import 'package:senior_circle/features/individual_chat/bloc/individual_chat_bloc.dart';
import 'package:senior_circle/features/individual_chat/presentation/my_circle_individual_chat_page.dart';
import 'package:senior_circle/features/circle_chat/bloc/circle_chat_bloc.dart';
import 'package:senior_circle/features/circle_chat/bloc/circle_chat_event.dart';
import 'package:senior_circle/features/circle_chat/bloc/forward_bloc.dart';
import 'package:senior_circle/features/circle_chat/bloc/forward_event.dart';
import 'package:senior_circle/features/circle_chat/bloc/forward_state.dart';
import 'package:senior_circle/features/circle_chat/models/circle_chat_message_model.dart';
import 'package:senior_circle/features/circle_chat/presentation/page/circle_chat_page.dart';

class ForwardBottomSheet extends StatefulWidget {
  final CircleChatMessage message;

  const ForwardBottomSheet({super.key, required this.message});

  @override
  State<ForwardBottomSheet> createState() => _ForwardBottomSheetState();
}

class _ForwardBottomSheetState extends State<ForwardBottomSheet> {
  @override
  void initState() {
    super.initState();
    context.read<ForwardBloc>().add(LoadForwardTargets());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForwardBloc, ForwardState>(
      listener: (context, state) {
        if (state is ForwardSuccess) {
          Navigator.pop(context); // Close bottom sheet
          Navigator.of(context).pop(); // Close message options if open
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ForwardError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ForwardNavigateToGroup) {
          Navigator.pop(context);
          
          final chatBloc = context.read<CircleChatBloc>();
          chatBloc.add(ForwardMessage(
            message: state.message,
            individualTargets: const [],
            circleIds: [state.chat.id],
          ));

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => CircleChatPage(
                  chat: state.chat,
                  isAdmin: state.isAdmin,
                  isForwarding: true,
                ),
              ),
            );
        } else if (state is ForwardNavigateToIndividual) {
          Navigator.pop(context);

          final individualChatBloc = context.read<IndividualChatBloc>();
          individualChatBloc.add(PrefillIndividualChat(
            text: state.message.text,
            mediaUrl: state.message.imagePath,
          ));

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => MyCircleIndividualChatPage(chat: state.chat),
            ),
          );
        }
      },
      child: _ForwardContent(message: widget.message),
    );
  }
}

class _ForwardContent extends StatelessWidget {
  final CircleChatMessage message;

  const _ForwardContent({required this.message});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: Column(
          children: [
            _ForwardHeader(),
            SearchBarWidget(
              hintText: 'Search',
              onChanged: (value) => 
                  context.read<ForwardBloc>().add(FilterTargets(value)),
            ),
            const Flexible(child: _ForwardList()),
            BlocBuilder<ForwardBloc, ForwardState>(
              builder: (context, state) {
                return BottomButton(
                  buttonText: 'FORWARD',
                  onTap: () {
                    context.read<ForwardBloc>().add(SubmitForward(message));
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _ForwardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const Text(
            'Forward',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          BlocBuilder<ForwardBloc, ForwardState>(
            builder: (context, state) {
              int count = 0;
              if (state is ForwardLoaded) {
                count = state.selectedItems.length;
              }
              
              if (count == 0) return const SizedBox.shrink();

              return Text(
                '$count selected',
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ForwardList extends StatelessWidget {
  const _ForwardList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForwardBloc, ForwardState>(
      builder: (context, state) {
        if (state is ForwardLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ForwardLoaded) {
          if (state.filteredItems.isEmpty) {
            return const Center(child: Text('No targets found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.only(top: 8),
            itemCount: state.filteredItems.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = state.filteredItems[index];
              final isSelected = state.selectedItems.contains(item);

              return ListTile(
                leading: Stack(
                  children: [
                    CircleAvatar(
                      backgroundImage: item.avatarUrl != null && item.avatarUrl!.isNotEmpty
                          ? NetworkImage(item.avatarUrl!)
                          : null,
                      child: item.avatarUrl == null || item.avatarUrl!.isEmpty
                          ? Icon(item.isGroup ? Icons.groups : Icons.person)
                          : null,
                    ),
                    if (item.isGroup)
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: const Icon(Icons.groups, size: 10, color: Colors.blue),
                        ),
                      ),
                  ],
                ),
                title: Text(item.name),
                subtitle: Text(item.isGroup ? 'Circle' : 'Friend'),
                trailing: Checkbox(
                  value: isSelected,
                  onChanged: (val) => context.read<ForwardBloc>().add(ToggleSelection(item)),
                ),
                onTap: () => context.read<ForwardBloc>().add(ToggleSelection(item)),
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
