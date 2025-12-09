import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/common/widgets/bottom_button.dart';
import 'package:senior_circle/common/widgets/common_app_bar.dart';
import 'package:senior_circle/common/widgets/image_picker_widget.dart';
import 'package:senior_circle/common/widgets/text_field_with_counter.dart';
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

  File? _selectedImageFile;
  XFile? _selectedXFile;

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
      appBar: const CommonAppBar(title: 'Create Room', activeCount: null),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImagePickerCircle(
              onImageSelected: (XFile? file) {
                setState(() {
                  _selectedXFile = file;
                  _selectedImageFile = file != null ? File(file.path) : null;
                });
              },
            ),

            const SizedBox(height: 20),

            TextFieldWithCounter(
              controller: _roomNameController,
              hintText: 'Give your room name',
              maxLength: 40,
              label: 'Room Name',
            ),

            TextFieldWithCounter(
              controller: _descriptionController,
              hintText: 'Describe your room',
              maxLength: 200,
              label: 'Description',
            ),

            LocationTextField(controller: null),

            InterestPicker(
              allInterests: AppLists.interests,
              onChanged: (selected) {
                print("Selected Interests: $selected");
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: ConfirmButton(
        onTap: () {
          print("Create Room Tapped");
        },
      ),
    );
  }
}
