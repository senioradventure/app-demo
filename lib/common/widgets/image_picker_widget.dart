import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCircle extends StatelessWidget {
  final VoidCallback? onImagePicked; // tap callback
  final XFile? image;
  final double size; // picked image

  const ImagePickerCircle({
    super.key,
    this.onImagePicked,
    this.image,
    this.size = 74,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onImagePicked,
      child: SizedBox(
        width: size,
        height: size,
        child: image == null
            ? SvgPicture.asset('assets/icons/camera.svg', fit: BoxFit.contain)
            : CircleAvatar(
                radius: size / 2,
                backgroundImage: FileImage(File(image!.path)),
              ),
      ),
    );
  }
}
