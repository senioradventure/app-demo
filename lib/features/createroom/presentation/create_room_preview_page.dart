import 'package:flutter/material.dart';
import 'package:senior_circle/core/common/widgets/bottom_button.dart';
import 'package:senior_circle/core/common/widgets/common_app_bar.dart';
import 'package:senior_circle/features/createroom/models/createroom_preview_details_model.dart';
import 'package:senior_circle/features/createroom/presentation/widgets/create_room_preview_details_widget.dart';
import 'package:senior_circle/features/createroom/repositories/createroom_repository.dart';
import 'package:senior_circle/features/preview/presentation/widgets/preview_screen_caution_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateRoomPreviewPage extends StatelessWidget {
  final CreateroomPreviewDetailsModel previewDetails;

  const CreateRoomPreviewPage({super.key, required this.previewDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Preview"),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: CreateRoomPreviewDetailsWidget(
              imageFile: previewDetails.imageFile,
              name: previewDetails.name,
              interests: previewDetails.interests,
              description: previewDetails.description,
            ),
          ),

          const CautionWidget(),
        ],
      ),
      bottomNavigationBar: BottomButton(
        buttonText: "CREATE ROOM",
        onTap: () async {
          final repo = CreateRoomRepository();
          final user = Supabase.instance.client.auth.currentUser;

          if (user == null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("User not logged in")));
            return;
          }

          try {
            await repo.createRoom(
              preview: previewDetails,
              adminId: user.id,
              // locationId: optional UUID if you have it
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Room created successfully")),
            );

            Navigator.popUntil(context, (route) => route.isFirst);
          } catch (e) {
            debugPrint("Create room error: $e");
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error: $e")));
          }
        },
      ),
    );
  }
}
