import 'dart:io';
import 'package:flutter/material.dart';
import 'package:senior_circle/core/theme/colors/app_colors.dart';

class ImageMessageBubble extends StatelessWidget {
  final String imagePath;
  final bool isMe;
  final bool isGroup;

  const ImageMessageBubble({
    super.key,
    required this.imagePath,
    required this.isMe,
    required this.isGroup,
  });

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage = imagePath.startsWith('http');

    return Align(
      alignment: isGroup
          ? Alignment.centerLeft
          : (isMe ? Alignment.centerRight : Alignment.centerLeft),
      child: Container(
        margin: isGroup
            ? const EdgeInsets.symmetric(vertical: 1)
            : const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isGroup
              ? null
              : isMe
              ? AppColors.lightBlue
              : Colors.white,
          borderRadius: isGroup
              ? BorderRadius.circular(8)
              : BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: isNetworkImage
              ? Image.network(
                  imagePath,
                  width: isGroup ? double.infinity : 254,
                  height: isGroup
                      ? 201
                      : MediaQuery.of(context).size.height * 0.2,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 200,
                      child: Center(child: Icon(Icons.broken_image)),
                    );
                  },
                )
              : Image.file(
                  File(imagePath),
                  width: isGroup ? double.infinity : 254,
                  height: isGroup
                      ? 201
                      : MediaQuery.of(context).size.height * 0.2,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
