import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/circle_chat/bloc/circle_chat_bloc.dart';
import 'package:senior_circle/features/circle_chat/bloc/circle_chat_event.dart';
import 'package:senior_circle/features/circle_chat/bloc/circle_chat_state.dart';
import 'package:senior_circle/features/circle_chat/models/circle_chat_message_model.dart';
import 'package:senior_circle/core/common/widgets/message_input_widget/message_input_field.dart';
import 'package:senior_circle/features/circle_chat/presentation/widgets/circle_chat_page_app_bar.dart';
import 'package:senior_circle/features/circle_chat/presentation/widgets/circle_chat_message_card.dart';
import 'package:senior_circle/features/my_circle_home/models/my_circle_model.dart';

class CircleChatPage extends StatefulWidget {
  const CircleChatPage({
    super.key,
    required this.chat,
    required this.isAdmin,
    this.isForwarding = false,
  });
  final MyCircle chat;
  final bool isAdmin;
  final bool isForwarding;

  @override
  State<CircleChatPage> createState() => _CircleChatPageState();
}

class _CircleChatPageState extends State<CircleChatPage> {
  final ScrollController _scrollController = ScrollController();
  bool _initialScrollDone = false;
  late final CircleChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();
    _chatBloc = context.read<CircleChatBloc>();

    if (!widget.isForwarding) {
      _chatBloc.add(ClearForwardingState());
    }

    _chatBloc.add(LoadGroupMessages(chatId: widget.chat.id));
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
      appBar: CircleChatPageAppBar(
        chat: widget.chat,
        isAdmin: widget.isAdmin,
      ),
      body: Column(
        children: [
          BlocListener<CircleChatBloc, CircleChatState>(
            listenWhen: (previous, current) =>
                previous.groupMessages.length != current.groupMessages.length,
            listener: (context, state) {
              if (state.groupMessages.isEmpty) return;

              if (!_initialScrollDone) {
                _initialScrollDone = true;
                _scrollToBottom();
                return;
              }

              _scrollToBottom();
            },
            child: Expanded(
              child: BlocSelector<CircleChatBloc, CircleChatState, List<CircleChatMessage>>(
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

                      return CircleChatMessageCard(
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
          BlocBuilder<CircleChatBloc, CircleChatState>(
            buildWhen: (previous, current) {
              return previous.isSending != current.isSending ||
                  previous.imagePath != current.imagePath ||
                  previous.filePath != current.filePath ||
                  previous.prefilledInputText != current.prefilledInputText ||
                  previous.prefilledMedia != current.prefilledMedia;
            },
            builder: (context, state) {
              return MessageInputFieldWidget(
                initialText: state.prefilledInputText,
                replyTo: null,
                imagePath: state.imagePath,
                filePath: state.filePath,
                isSending: state.isSending,
                
                onClearReply: () {
                  
                },
                
                onPickImage: () async {
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    context.read<CircleChatBloc>().add(
                      PickMessageImage(image.path),
                    );
                  }
                },

                onPickCamera: () async {
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    context.read<CircleChatBloc>().add(
                      PickMessageImage(image.path),
                    );
                  }
                },

                onPickFile: () async {
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    withData: false,
                  );

                  if (result != null && result.files.single.path != null) {
                    context.read<CircleChatBloc>().add(
                      PickMessageFile(result.files.single.path!),
                    );
                  }
                },

                onRemoveFile: () {
                  context.read<CircleChatBloc>().add(RemovePickedFile());
                },

                onRemoveImage: () {
                  context.read<CircleChatBloc>().add(RemovePickedImage());
                },

                onSend: (text) {
                  context.read<CircleChatBloc>().add(
                    SendGroupMessage(
                      text: text,
                      circleId: widget.chat.id,
                    ),
                  );
                },

                onSendVoice: (audioFile) {
                  context.read<CircleChatBloc>().add(
                    SendVoiceMessage(audioFile: audioFile.path),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
