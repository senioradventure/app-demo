import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senior_circle/core/common/widgets/bottom_button.dart';
import 'package:senior_circle/core/common/widgets/common_app_bar.dart';
import 'package:senior_circle/core/common/widgets/image_picker_widget.dart';
import 'package:senior_circle/core/common/widgets/text_field_with_counter.dart';
import 'package:senior_circle/features/auth/bloc/auth_bloc.dart';
import 'package:senior_circle/features/auth/model/auth_model.dart';
import 'package:senior_circle/features/auth/presentation/widgets/location_picker_create_user.dart';
import 'package:senior_circle/features/tab/tab.dart';

class CreateUserPage extends StatelessWidget {
  const CreateUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthModel? authModel = context.select<AuthBloc, AuthModel?>(
      (bloc) => bloc.state is CreateUserState
          ? (bloc.state as CreateUserState).authModel
          : null,
    );
    final isLoading = context.select<AuthBloc, bool>(
      (bloc) =>
          bloc.state is CreateUserState &&
          (bloc.state as CreateUserState).isSubmitting,
    );

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is CreateUserSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => TabSelectorWidget()),
            (_) => false,
          );
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: const CommonAppBar(title: "Create User"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Column(
              children: [
                /// 🔹 Profile Image Picker
                if (authModel != null)
                  ImagePickerCircle(
                    image: authModel.profileFile.path.isNotEmpty
                        ? XFile(authModel.profileFile.path)
                        : null,
                    onImagePicked: () {
                      context.read<AuthBloc>().add(
                        PickProfileFromGalleryEvent(),
                      );
                    },
                  ),

                const SizedBox(height: 24),

                /// 🔹 Name field
                TextFieldWithCounter(
                  label: "Name",
                  hintText: "Enter your name",
                  count: authModel?.name.length ?? 0,
                  maxLength: 20,
                  onChanged: (value) {
                    context.read<AuthBloc>().add(AuthNameUpdated(value));
                  },
                ),

                const SizedBox(height: 16),

                /// 🔹 Location picker
                LocationPickerCreateUser(
                  onChanged: (location) {
                    if (location != null) {
                      context.read<AuthBloc>().add(
                        AuthLocationUpdated(location.id),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomButton(
          buttonText: "Create",
          isLoading: isLoading,
          onTap: isLoading
              ? null
              : () {
                  context.read<AuthBloc>().add(SubmitCreateUserEvent());
                },
        ),
      ),
    );
  }
}
