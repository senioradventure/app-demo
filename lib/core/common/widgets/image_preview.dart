import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImagePreview extends StatelessWidget {
  final XFile selectedImage;
  final VoidCallback onRemove;

  const ImagePreview({
    super.key,
    required this.selectedImage,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isNetwork = selectedImage.path.startsWith('http');

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: isNetwork
                ? CachedNetworkImage(
                    imageUrl: selectedImage.path,
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.broken_image),
                    ),
                  )
                : Image.file(
                    File(selectedImage.path),
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),

          Positioned(
            top: 6,
            right: 6,
            child: InkWell(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
