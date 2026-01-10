import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/common/widgets/image_preview.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/individual_chat/bloc/individual_chat_bloc.dart';

class IndividualMessageInputField extends StatefulWidget {
  const IndividualMessageInputField({super.key});

  @override
  State<IndividualMessageInputField> createState() => _IndividualMessageInputFieldState();
}

class _IndividualMessageInputFieldState extends State<IndividualMessageInputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IndividualChatBloc, IndividualChatState>(
      listenWhen: (prev, curr) {
        if (curr is IndividualChatLoaded) {
          if (prev is! IndividualChatLoaded) return true;
          
          return prev.prefilledInputText != curr.prefilledInputText ||
                 prev.prefilledMediaUrl != curr.prefilledMediaUrl;
        }
        return false;
      },
      listener: (context, state) {
        if (state is IndividualChatLoaded) {
          if (state.prefilledInputText != null) {
            _controller.text = state.prefilledInputText!;
          }
          if (state.prefilledMediaUrl != null) {
            // Already handled in the builder by showing an Image.network preview
          }
        }
      },
      buildWhen: (prev, curr) {
        if (prev is IndividualChatLoaded && curr is IndividualChatLoaded) {
          return prev.replyTo != curr.replyTo ||
              prev.imagePath != curr.imagePath ||
              prev.isSending != curr.isSending ||
              prev.prefilledMediaUrl != curr.prefilledMediaUrl;
        }
        return true;
      },
      builder: (context, state) {
        if (state is! IndividualChatLoaded) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          color: AppColors.lightGray,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ---------------- REPLY PREVIEW ----------------
              if (state.replyTo != null)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          state.replyTo!.content.isNotEmpty
                              ? state.replyTo!.content
                              : '📷 Image',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () {
                          context.read<IndividualChatBloc>().add(
                            ClearReplyMessage(),
                          );
                        },
                      ),
                    ],
                  ),
                ),

              /// ---------------- IMAGE PREVIEW ----------------
              if (state.imagePath != null || state.prefilledMediaUrl != null)
                Stack(
                  children: [
                    if (state.imagePath != null)
                      ImagePreview(
                        selectedImage: XFile(state.imagePath!),
                        onRemove: () {
                          context.read<IndividualChatBloc>().add(RemovePickedImage());
                        },
                      ),
                    if (state.imagePath == null && state.prefilledMediaUrl != null)
                       Padding(
                         padding: const EdgeInsets.only(bottom: 8.0),
                         child: Stack(
                           children: [
                             ClipRRect(
                               borderRadius: BorderRadius.circular(8),
                               child: Image.network(
                                 state.prefilledMediaUrl!,
                                 height: 100,
                                 width: 100,
                                 fit: BoxFit.cover,
                               ),
                             ),
                             Positioned(
                               top: 4,
                               right: 4,
                               child: GestureDetector(
                                 onTap: () {
                                   context.read<IndividualChatBloc>().add(
                                     const PrefillIndividualChat(mediaUrl: null),
                                   );
                                 },
                                 child: Container(
                                   padding: const EdgeInsets.all(2),
                                   decoration: const BoxDecoration(
                                     color: Colors.black54,
                                     shape: BoxShape.circle,
                                   ),
                                   child: const Icon(Icons.close, size: 16, color: Colors.white),
                                 ),
                               ),
                             ),
                           ],
                         ),
                       ),
                  ],
                ),

              /// ---------------- INPUT ROW ----------------
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      final image = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (image != null) {
                        context.read<IndividualChatBloc>().add(
                          PickMessageImage(image.path),
                        );
                        // Also clear prefilled media if a new one is picked
                        if (state.prefilledMediaUrl != null) {
                           context.read<IndividualChatBloc>().add(
                             const PrefillIndividualChat(mediaUrl: null),
                           );
                        }
                      }
                    },
                    child: SvgPicture.asset(
                      'assets/icons/add_media_chat_icon.svg',
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: state.isSending
                        ? null
                        : () {
                            final text = _controller.text.trim();
                            if (text.isEmpty && state.imagePath == null && state.prefilledMediaUrl == null) return;

                            if (state.prefilledMediaUrl != null && state.imagePath == null) {
                                // Specific handling for forwarding with ALREADY uploaded media
                                context.read<IndividualChatBloc>().add(
                                  SendConversationMessage(text: text),
                                );
                            } else {
                                context.read<IndividualChatBloc>().add(
                                  SendConversationMessage(text: text),
                                );
                            }

                            _controller.clear();
                            // Clear prefilled states after sending
                            if (state.prefilledInputText != null || state.prefilledMediaUrl != null) {
                               context.read<IndividualChatBloc>().add(
                                 const PrefillIndividualChat(text: null, mediaUrl: null),
                               );
                            }
                          },
                    child: SvgPicture.asset('assets/icons/send_icon.svg'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
