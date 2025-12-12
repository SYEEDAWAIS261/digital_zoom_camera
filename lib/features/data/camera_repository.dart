import 'dart:io';
import 'package:camera/camera.dart';
import '../../../core/services/camera_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/logger.dart';
import '../../../app/constants.dart';

class CameraRepository {
  final CameraService cameraService;

  CameraRepository({required this.cameraService});

  CameraController? get controller => cameraService.controller;

  /// Initialize camera (hardware setup)
  Future<void> initializeCamera() async {
    await cameraService.initialize();
    Logger.info("CameraRepository: Camera initialized successfully.");
  }

  /// Capture photo with maximum quality and save locally
  /// Returns saved file path or null if failed
  Future<String?> capturePhoto({int? jpegQuality}) async {
    try {
      if (controller == null || !controller!.value.isInitialized) {
        Logger.error("CameraRepository: Cannot capture, camera not initialized.");
        return null;
      }

      // Capture image from camera service
      final xFile = await cameraService.capture();
      if (xFile == null) return null;

      // Read image bytes
      final bytes = await xFile.readAsBytes();

      // Save using StorageService with max quality
      final file = await StorageService.saveImage(
        bytes,
        quality: jpegQuality ?? AppConstants.imageCompressionQuality,
      );

      if (file != null) {
        Logger.info("CameraRepository: Photo saved at ${file.path}");
      } else {
        Logger.error("CameraRepository: Failed to save photo.");
      }

      return file?.path;
    } catch (e) {
      Logger.error("CameraRepository: Capture failed - $e");
      return null;
    }
  }

  /// Dispose camera safely
  void dispose() => cameraService.dispose();
}
