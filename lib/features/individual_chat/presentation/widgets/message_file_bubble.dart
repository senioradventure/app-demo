import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageFileBubble extends StatefulWidget {
  final String? localPath;
  final String? fileUrl;
  final bool isMe;

  const MessageFileBubble({
    super.key,
    this.localPath,
    this.fileUrl,
    required this.isMe,
  }) : assert(
         localPath != null || fileUrl != null,
         'Either localPath or fileUrl must be provided',
       );

  @override
  State<MessageFileBubble> createState() => _MessageFileBubbleState();
}

class _MessageFileBubbleState extends State<MessageFileBubble> {
  bool _isDownloading = false;

  Future<void> _downloadFile(BuildContext context) async {
    try {
      setState(() => _isDownloading = true);

      /// 🔐 Request storage permission (Android)
      final permission = await Permission.storage.request();
      if (!permission.isGranted) {
        _showSnack(context, 'Storage permission denied');
        return;
      }

      final fileName = Uri.parse(widget.fileUrl ?? '').pathSegments.last;

      final directory = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();

      final filePath = '${directory!.path}/$fileName';

      await Dio().download(
        widget.fileUrl ?? '',
        filePath,
        options: Options(responseType: ResponseType.bytes),
      );

      _showSnack(context, 'File downloaded: $fileName');
    } catch (e) {
      print(e.toString());
      _showSnack(context, 'Download failed');
    } finally {
      setState(() => _isDownloading = false);
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    // Determine which path to use and extract filename
    final String displayPath = widget.localPath ?? widget.fileUrl ?? '';
    final fileName = displayPath.contains('/')
        ? displayPath.split('/').last
        : 'Unknown file';

    return GestureDetector(
      onTap: _isDownloading ? null : () => _downloadFile(context),
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.isMe ? Colors.blue.shade100 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _isDownloading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(
                    Icons.insert_drive_file,
                    size: 22,
                    color: Colors.black87,
                  ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                fileName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.download, size: 18, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
