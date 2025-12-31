import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/common/widgets/bottom_button.dart';
import 'package:senior_circle/core/common/widgets/common_app_bar.dart';
import 'package:senior_circle/core/common/widgets/image_picker_widget.dart';
import 'package:senior_circle/core/common/widgets/text_field_with_counter.dart';
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
  final TextEditingController _nameController = TextEditingController();

  int _nameCount = 0;
  String? _selectedLocationId;

  @override
  void initState() {
    super.initState();
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
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded) {
            final loadedState = state;
            if (_nameController.text.isEmpty) {
              _nameController.text = loadedState.profile.fullName ?? '';
              _selectedLocationId = loadedState.profile.locationId?.toString();
              _nameCount = _nameController.text.length;
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  ImagePickerCircle(
                    networkImage: loadedState.profile.avatarUrl,
                    image: loadedState.profileImageFile,
                    onImagePicked: () {
                      context.read<ProfileBloc>().add(PickProfileImage());
                    },
                  ),

                  const SizedBox(height: 16),
                  TextFieldWithCounter(
                    label: 'Name',
                    hintText: 'Give your name',
                    maxLength: 40,
                    count: _nameController.text.length,
                    controller: _nameController,
                    onChanged: (value) {
                      context.read<ProfileBloc>().add(
                        UpdateProfile(fullName: value),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  ProfileLocationDropdown(
                    onChanged: (location) {
                      if (location != null) {
                        context.read<ProfileBloc>().add(
                          UpdateProfile(locationId: location.id),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),

      bottomNavigationBar: BottomButton(
        buttonText: 'Save',
        onTap: () {
          context.read<ProfileBloc>().add(SubmitProfile());
          Navigator.pop(context);
        },
      ),
    );
  }
}
