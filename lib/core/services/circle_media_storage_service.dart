import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class CircleMediaStorageService {
  Future<Directory> getCircleMediaDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${appDir.path}/media');
    
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    
    return mediaDir;
  }

  Future<File> saveMediaLocally(File file, String type) async {
    try {
      final mediaDir = await getCircleMediaDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = path.extension(file.path);
      final basename = path.basenameWithoutExtension(file.path);
      
      // Create type-specific subdirectory
      final typeDir = Directory('${mediaDir.path}/$type');
      if (!await typeDir.exists()) {
        await typeDir.create(recursive: true);
      }
      
      // Create unique filename with timestamp
      final newPath = '${typeDir.path}/${timestamp}_$basename$extension';
      
      // Copy file to new location
      return await file.copy(newPath);
    } catch (e) {
      debugPrint('❌ [MediaStorage] Failed to save file: $e');
      debugPrint('❌ [MediaStorage] File path: ${file.path}');
      debugPrint('❌ [MediaStorage] Type: $type');
      rethrow; // Let caller handle the error
    }
  }

  /// Get the path to a specific media file
  Future<String?> getLocalPath(String filename) async {
    final mediaDir = await getCircleMediaDirectory();
    
    // Search in all subdirectories
    for (final type in ['images', 'files', 'voice']) {
      final file = File('${mediaDir.path}/$type/$filename');
      if (await file.exists()) {
        return file.path;
      }
    }
    
    return null;
  }
}
