import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import '../../app/constants.dart';
import '../utils/logger.dart';

/// ---------------------------------------------------------------------------
///                         STORAGE SERVICE (Pro Version)
///  - Saves images safely with proper file naming
///  - Creates app folder if missing
///  - Supports PNG/JPG automatically
///  - Clean, stable, production-ready
/// ---------------------------------------------------------------------------
class StorageService {
  /// Save an image from raw bytes into app storage.
  ///
  /// Returns the **File** if saved successfully, otherwise null.
  static Future<File?> saveImage(Uint8List bytes, {int? quality}) async {
    try {
      Logger.info("💾 Preparing to save image...");

      // 1. Get application document directory
      final appDir = await getApplicationDocumentsDirectory();

      // 2. Create folder DigitalZoomImages
      final folderDir = Directory("${appDir.path}/${AppConstants.imageFolder}");

      if (!await folderDir.exists()) {
        await folderDir.create(recursive: true);
        Logger.info("📁 Created folder: ${folderDir.path}");
      }

      // 3. Build filename according to AppConstants
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename =
          "${AppConstants.filePrefix}$timestamp.${AppConstants.imageFormat}";

      // 4. Full file path
      final file = File("${folderDir.path}/$filename");

      // 5. Compress image if quality is specified
      Uint8List finalBytes = bytes;
      if (quality != null) {
        final image = img.decodeJpg(bytes);
        if (image != null) {
          finalBytes = img.encodeJpg(image, quality: quality);
        }
      }

      // 6. Write file safely
      await file.writeAsBytes(finalBytes, flush: true);

      Logger.info("✅ Image saved successfully: ${file.path}");
      return file;
    } catch (e, stack) {
      Logger.error("❌ Failed to save image: $e");
      Logger.debug("$stack");
      return null;
    }
  }
}
