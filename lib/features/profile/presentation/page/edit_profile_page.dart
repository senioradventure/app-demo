import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/common/widgets/common_app_bar.dart';
import 'package:senior_circle/core/common/widgets/image_picker_widget.dart';
import 'package:senior_circle/core/common/widgets/text_field_with_counter.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:senior_circle/features/profile/bloc/profile_bloc.dart';
import 'package:senior_circle/features/profile/bloc/profile_event.dart';
import 'package:senior_circle/features/profile/bloc/profile_state.dart';
import 'package:senior_circle/features/profile/presentation/widgets/location_dropdown.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? _selectedLocation;
  String _imageUrl = '';

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

  XFile? _pickedImage;
  String? _imagePath;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _pickedImage = image;
        _imagePath = image.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    final state = context.read<ProfileBloc>().state;
    if (state is ProfileLoaded) {
      _nameController.text = state.profile.name;
      _selectedLocation = state.profile.location;
      _imageUrl = state.profile.imageUrl;
      _nameCount = _nameController.text.length;
    }

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
            ImagePickerCircle(image: _pickedImage, onImagePicked: _pickImage),
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
          decoration: const BoxDecoration(color: AppColors.bottomButtonBlue),
          child: ElevatedButton(
            onPressed: _onSavePressed,
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

  void _onSavePressed() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
      return;
    }

    context.read<ProfileBloc>().add(
      UpdateProfile(
        name: _nameController.text.trim(),
        location: _selectedLocation!,
        imageUrl: _imageUrl,
      ),
    );

    Navigator.pop(context);
  }
}
