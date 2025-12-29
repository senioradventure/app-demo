import 'package:flutter/material.dart';
import 'package:senior_circle/core/common/widgets/common_app_bar.dart';
import 'package:senior_circle/core/common/widgets/image_picker_widget.dart';
import 'package:senior_circle/core/common/widgets/text_field_with_counter.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/createroom/presentation/widgets/create_room_location_picker.dart';
import 'package:senior_circle/features/edit_profile/presentation/widgets/location_dropdown.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? _selectedLocation;

  final List<String> _locations = [
    'Kochi',
    'Trivandrum',
    'Calicut',
    'Bangalore',
    'Chennai',
    'Hyderabad',
  ];

  final TextEditingController _nameController = TextEditingController();
  int _nameCount = 0;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      setState(() {
        _nameCount = _nameController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Edit Profile'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const ImagePickerCircle(),
            const SizedBox(height: 20),
            TextFieldWithCounter(
              label: 'Name',
              hintText: 'Give your name',
              maxLength: 40,
              count: _nameCount,
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  _nameCount = value.length;
                });
              },
            ),
            const SizedBox(height: 16),
            LocationDropdown(
              value: _selectedLocation,
              locations: _locations,
              onChanged: (value) {
                setState(() {
                  _selectedLocation = value;
                });
              },
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(color: AppColors.bottomButtonBlue),
          child: ElevatedButton(
            onPressed: () {
              if (_nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Name cannot be empty')),
                );
                return;
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'SAVE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
