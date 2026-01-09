import 'package:flutter/material.dart';
import 'package:senior_circle/features/individual_chat/presentation/widgets/attachment_tile_widget.dart';

void showAttachmentPicker(
  BuildContext context,
  VoidCallback onPickImage,
  VoidCallback onPickCamera,
  VoidCallback onPickFile,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AttachmentTile(
              icon: Icons.photo,
              title: 'Gallery',
              onTap: () {
                Navigator.pop(context);
                onPickImage();
              },
            ),
            AttachmentTile(
              icon: Icons.camera_alt,
              title: 'Camera',
              onTap: () {
                Navigator.pop(context);
                onPickCamera();
              },
            ),
            AttachmentTile(
              icon: Icons.insert_drive_file,
              title: 'File',
              onTap: () {
                Navigator.pop(context);
                onPickFile();
              },
            ),
          ],
        ),
      );
    },
  );
}
