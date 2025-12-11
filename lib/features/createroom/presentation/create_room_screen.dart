import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/common/widgets/bottom_button.dart';
import 'package:senior_circle/common/widgets/common_app_bar.dart';
import 'package:senior_circle/common/widgets/image_picker_widget.dart';
import 'package:senior_circle/common/widgets/text_field_with_counter.dart';
import 'package:senior_circle/features/createroom/bloc/createroom_bloc.dart';
import 'package:senior_circle/features/createroom/presentation/widgets/create_room_interest_widget.dart';
import 'package:senior_circle/features/createroom/presentation/widgets/create_room_location_textfield_widget.dart';
import 'package:senior_circle/theme/strings/lists.dart';

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
      body: BlocBuilder<CreateroomBloc, CreateroomState>(
        builder: (context, state) {
          File? imageFile = state.imageFile;
          int nameCount = state.nameCount;
          int descriptionCount = state.descriptionCount;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImagePickerCircle(
                  image: imageFile != null ? XFile(imageFile.path) : null,
                  onImagePicked: () {
                    context.read<CreateroomBloc>().add(
                      PickImageFromGalleryEvent(),
                    );
                  },
                ),

                const SizedBox(height: 20),

                TextFieldWithCounter(
                  controller: _roomNameController,
                  hintText: 'Give your room name',
                  maxLength: 40,
                  label: 'Room Name',
                  count: nameCount,
                  onChanged: (value) {
                    context.read<CreateroomBloc>().add(
                      NameTextFieldCounterEvent(value.length),
                    );
                  },
                ),

                TextFieldWithCounter(
                  controller: _descriptionController,
                  hintText: 'Describe your room',
                  maxLength: 200,
                  label: 'Description',
                  count: descriptionCount,
                  onChanged: (value) {
                    context.read<CreateroomBloc>().add(
                      DisDescriptionTextFieldCounterEvent(value.length),
                    );
                  },
                ),

                const LocationTextField(controller: null),

                InterestPicker(
                  allInterests: AppLists.interests,
                  onChanged: (selected) {
                    debugPrint("Selected in Home: $selected");
                  },
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomButton(
        buttonText: 'CONFIRM',
        onTap: () {
          print("Create Room Tapped");
        },
      ),
    );
  }
}
