import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCircle extends StatelessWidget {
  final VoidCallback? onImagePicked; // tap callback
  final XFile? image;
  final String? networkImage;
  final double size; // picked image

  const ImagePickerCircle({
    super.key,
    this.onImagePicked,
    this.networkImage,
    this.image,
    this.size = 74,
  });

  @override
  Widget build(BuildContext context) {
     Widget child;

    if (image != null) {
      child = CircleAvatar(
        radius: size / 2,
        backgroundImage: FileImage(File(image!.path)),
      );
    } else if (networkImage != null && networkImage!.isNotEmpty) {
      
      child = CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(networkImage!),
      );
    } else {

      child = SvgPicture.asset(
        'assets/icons/camera.svg',
        fit: BoxFit.contain,
      );
    }

    return GestureDetector(
      onTap: onImagePicked,
      child: SizedBox(
        width: size,
        height: size,
        child: child,
      ),
    );
  }
}
