import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Service for managing local media file storage
/// Handles saving, retrieving, and organizing media files in the app's documents directory
class MediaStorageService {
  /// Base directory for all media files
  static const String _mediaBaseDir = 'media';

  /// Subdirectories for different media types
  static const String _imagesDir = 'images';
  static const String _filesDir = 'files';
  static const String _voiceDir = 'voice';
  static const String _audioDir = 'audio';

  /// Save a media file to local storage
  ///
  /// [sourceFile] - The file to save (from temporary location)
  /// [mediaType] - Type of media: 'image', 'file', 'audio', 'voice'
  ///
  /// Returns the absolute path to the saved file
  Future<String> saveMediaFile({
    required File sourceFile,
    required String mediaType,
  }) async {
    // Get the app's documents directory
    final appDocDir = await getApplicationDocumentsDirectory();

    // Determine subdirectory based on media type
    final String subDir = _getSubdirectory(mediaType);

    // Create the full directory path
    final mediaDir = Directory(p.join(appDocDir.path, _mediaBaseDir, subDir));

    // Create directory if it doesn't exist
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }

    // Generate unique filename using timestamp + original filename
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final originalName = p.basename(sourceFile.path);
    final newFileName = '${timestamp}_$originalName';

    // Create the destination file path
    final destinationPath = p.join(mediaDir.path, newFileName);

    // Copy the file to the destination
    final savedFile = await sourceFile.copy(destinationPath);

    return savedFile.path;
  }

  /// Get a File object from a local media path
  ///
  /// Returns null if the file doesn't exist
  File? getMediaFile(String? localPath) {
    if (localPath == null || localPath.isEmpty) return null;

    final file = File(localPath);
    return file.existsSync() ? file : null;
  }

  /// Check if a local media file exists
  bool mediaFileExists(String? localPath) {
    if (localPath == null || localPath.isEmpty) return false;
    return File(localPath).existsSync();
  }

  /// Delete a media file from local storage
  ///
  /// Returns true if file was deleted, false if it didn't exist
  Future<bool> deleteMediaFile(String? localPath) async {
    if (localPath == null || localPath.isEmpty) return false;

    final file = File(localPath);
    if (!await file.exists()) return false;

    try {
      await file.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get the subdirectory name based on media type
  String _getSubdirectory(String mediaType) {
    switch (mediaType.toLowerCase()) {
      case 'image':
        return _imagesDir;
      case 'file':
        return _filesDir;
      case 'audio':
        return _audioDir;
      case 'voice':
        return _voiceDir;
      default:
        return _filesDir; // Default to files directory
    }
  }

  /// Get the total size of all media files (optional utility)
  Future<int> getTotalMediaSize() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory(p.join(appDocDir.path, _mediaBaseDir));

    if (!await mediaDir.exists()) return 0;

    int totalSize = 0;
    await for (final entity in mediaDir.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }

    return totalSize;
  }

  /// Clear all media files (use with caution!)
  Future<void> clearAllMedia() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory(p.join(appDocDir.path, _mediaBaseDir));

    if (await mediaDir.exists()) {
      await mediaDir.delete(recursive: true);
    }
  }
}
