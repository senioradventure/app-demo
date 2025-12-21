import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageCompressor {
  static Future<File?> compressImage({
    required File imageFile,
    int quality = 70, // 0 - 100
    int minWidth = 1080,
    int minHeight = 1080,
  }) async {
    final dir = await getTemporaryDirectory();

    final targetPath = path.join(
      dir.path,
      'compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      targetPath,
      quality: quality,
      minWidth: minWidth,
      minHeight: minHeight,
      format: CompressFormat.jpeg,
    );

    if (compressedFile == null) return null;

    return File(compressedFile.path);
  }
}
