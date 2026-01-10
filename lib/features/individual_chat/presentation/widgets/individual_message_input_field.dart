import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/common/widgets/image_preview.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/individual_chat/bloc/individual_chat_bloc.dart';

class IndividualMessageInputField extends StatelessWidget {
  IndividualMessageInputField({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndividualChatBloc, IndividualChatState>(
      buildWhen: (prev, curr) {
        if (prev is IndividualChatLoaded && curr is IndividualChatLoaded) {
          return prev.replyTo != curr.replyTo ||
              prev.imagePath != curr.imagePath ||
              prev.isSending != curr.isSending;
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
              if (state.imagePath != null)
                ImagePreview(
                  selectedImage: XFile(state.imagePath!),
                  onRemove: () {
                    context.read<IndividualChatBloc>().add(RemovePickedImage());
                  },
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
                            if (text.isEmpty && state.imagePath == null) return;

                            context.read<IndividualChatBloc>().add(
                              SendConversationMessage(text: text),
                            );

                            _controller.clear();
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
