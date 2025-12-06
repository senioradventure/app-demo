import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerCircle extends StatefulWidget {
  final Function(XFile?) onImageSelected; // callback to return picked image
  final double size;
  final String placeholderAsset;

  const ImagePickerCircle({
    super.key,
    required this.onImageSelected,
    this.size = 74,
    this.placeholderAsset = 'assets/icons/camera.svg',
  });

  @override
  State<ImagePickerCircle> createState() => _ImagePickerCircleState();
}

class _ImagePickerCircleState extends State<ImagePickerCircle> {
  final ImagePicker _picker = ImagePicker();
  File? _file;

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _file = File(image.path);
      });

      widget.onImageSelected(image); // return XFile to parent
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickImage,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: _file == null
            ? SvgPicture.asset(widget.placeholderAsset, fit: BoxFit.contain)
            : CircleAvatar(
                radius: widget.size / 2,
                backgroundImage: FileImage(_file!),
              ),
      ),
    );
  }
}
