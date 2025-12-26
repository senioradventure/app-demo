import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/common/widgets/bottom_button.dart';
import 'package:senior_circle/core/common/widgets/common_app_bar.dart';
import 'package:senior_circle/core/common/widgets/image_picker_widget.dart';
import 'package:senior_circle/core/common/widgets/text_field_with_counter.dart';
import 'package:senior_circle/core/constants/strings/lists.dart';
import 'package:senior_circle/features/createroom/bloc/createroom_bloc.dart';
import 'package:senior_circle/features/createroom/presentation/create_room_preview_page.dart';
import 'package:senior_circle/features/createroom/presentation/widgets/create_room_interest_widget.dart';
import 'package:senior_circle/features/createroom/presentation/widgets/create_room_location_picker.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  late TextEditingController _roomNameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _roomNameController = TextEditingController();
    _descriptionController = TextEditingController();
    context.read<CreateroomBloc>().add(ResetCreateRoomEvent());
    context.read<CreateroomBloc>().add(LoadLocationsEvent());
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Create Room'),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          children: [
            /// 🔹 IMAGE PICKER (rebuild only on image change)
            BlocBuilder<CreateroomBloc, CreateroomState>(
              buildWhen: (prev, curr) => prev.imageFile != curr.imageFile,
              builder: (context, state) {
                return ImagePickerCircle(
                  image: state.imageFile != null
                      ? XFile(state.imageFile!.path)
                      : null,
                  onImagePicked: () {
                    context.read<CreateroomBloc>().add(
                      PickImageFromGalleryEvent(),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 20),

            /// 🔹 ROOM NAME FIELD
            BlocBuilder<CreateroomBloc, CreateroomState>(
              buildWhen: (prev, curr) => prev.nameCount != curr.nameCount,
              builder: (context, state) {
                return TextFieldWithCounter(
                  controller: _roomNameController,
                  label: 'Room Name',
                  hintText: 'Give your room name',
                  maxLength: 40,
                  count: state.nameCount,
                  onChanged: (value) {
                    context.read<CreateroomBloc>().add(
                      NameTextFieldCounterEvent(value.length),
                    );
                  },
                );
              },
            ),

            /// 🔹 DESCRIPTION FIELD
            BlocBuilder<CreateroomBloc, CreateroomState>(
              buildWhen: (prev, curr) =>
                  prev.descriptionCount != curr.descriptionCount,
              builder: (context, state) {
                return TextFieldWithCounter(
                  controller: _descriptionController,
                  label: 'Description',
                  hintText: 'Describe your room',
                  maxLength: 200,
                  count: state.descriptionCount,
                  onChanged: (value) {
                    context.read<CreateroomBloc>().add(
                      DisDescriptionTextFieldCounterEvent(value.length),
                    );
                  },
                );
              },
            ),
            const LocationPicker(),
            InterestPicker(allInterests: AppLists.interests),
          ],
        ),
      ),

      /// 🔹 CONFIRM BUTTON + LISTENER
      bottomNavigationBar: BlocListener<CreateroomBloc, CreateroomState>(
        listenWhen: (prev, curr) => prev.status != curr.status,
        listener: (context, state) {
          final status = state.status;

          if (status is CreateroomValidationError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(status.message)));
          }

          if (status is CreateroomPreviewReady) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    CreateRoomPreviewPage(previewDetails: status.preview),
              ),
            );
          }
        },
        child: BottomButton(
          buttonText: 'CONFIRM',
          onTap: () {
            context.read<CreateroomBloc>().add(
              ConfirmCreateRoomEvent(
                roomName: _roomNameController.text,
                description: _descriptionController.text,
              ),
            );
          },
        ),
      ),
    );
  }
}
