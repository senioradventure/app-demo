import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class FileMessageBubble extends StatelessWidget {
  final String fileUrl;
  final bool isMe;
  final bool isGroup;

  const FileMessageBubble({
    super.key,
    required this.fileUrl,
    required this.isMe,
    required this.isGroup,
  });

  String get _fileName {
    try {
      // Decode URL to handle spaces/special chars and get the last segment
      return Uri.decodeFull(fileUrl).split('/').last.split('?').first;
    } catch (e) {
      return 'Attachment';
    }
  }

  Future<void> _launchFile() async {
    final uri = Uri.parse(fileUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isGroup
          ? Alignment.centerLeft
          : (isMe ? Alignment.centerRight : Alignment.centerLeft),
      child: GestureDetector(
        onTap: _launchFile,
        child: Container(
          width: isGroup ? double.infinity : 254,
          margin: isGroup
              ? const EdgeInsets.symmetric(vertical: 1)
              : const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isGroup
                ? const Color(0xFFF5F5F5) // Slightly grey for file background
                : isMe
                ? AppColors.lightBlue.withOpacity(0.3)
                : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.borderColor.withOpacity(0.5),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.insert_drive_file,
                  color: Colors.redAccent, // PDF/File color
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _fileName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.underline,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
