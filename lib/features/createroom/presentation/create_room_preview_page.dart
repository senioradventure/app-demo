import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:senior_circle/core/common/widgets/bottom_button.dart';
import 'package:senior_circle/core/common/widgets/common_app_bar.dart';
import 'package:senior_circle/features/createroom/models/createroom_preview_details_model.dart';
import 'package:senior_circle/features/createroom/presentation/widgets/create_room_preview_details_widget.dart';
import 'package:senior_circle/features/createroom/repositories/createroom_repository.dart';
import 'package:senior_circle/features/live_chat_chat_room/ui/live_chat_chat_room_page.dart';
import 'package:senior_circle/features/live_chat_home/presentation/bloc/live_chat_home_bloc.dart';
import 'package:senior_circle/features/preview/presentation/widgets/preview_screen_caution_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateRoomPreviewPage extends StatefulWidget {
  final CreateroomPreviewDetailsModel previewDetails;

  const CreateRoomPreviewPage({super.key, required this.previewDetails});

  @override
  State<CreateRoomPreviewPage> createState() => _CreateRoomPreviewPageState();
}

class _CreateRoomPreviewPageState extends State<CreateRoomPreviewPage> {
  bool _isLoading = false;

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
              imageFile: widget.previewDetails.imageFile,
              name: widget.previewDetails.name,
              interests: widget.previewDetails.interests,
              description: widget.previewDetails.description,
            ),
          ),
          const CautionWidget(),
        ],
      ),
      bottomNavigationBar: BottomButton(
        buttonText: "CREATE ROOM",
        isLoading: _isLoading,
        onTap: _isLoading ? null : () => _createRoom(context),
      ),
    );
  }

  Future<void> _createRoom(BuildContext context) async {
    final repo = CreateRoomRepository();
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User not logged in")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final roomId = await repo.createRoom(
        preview: widget.previewDetails,
        adminId: user.id,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Chatroom(
            title: widget.previewDetails.name,
            isAdmin: true,
            isNewRoom: true,
            imageFile: widget.previewDetails.imageFile,
          ),
        ),
      ).then((_) {
        context.read<LiveChatHomeBloc>().add(FetchRoomsEvent());
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: $e")));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
