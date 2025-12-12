import 'package:camera/camera.dart';
import '../utils/logger.dart';

class CameraService {
  CameraController? _controller;
  List<CameraDescription>? _cameras;

  CameraController? get controller => _controller;
  double maxZoom = 1.0;
  double minZoom = 1.0;

  bool get isInitialized => _controller != null && _controller!.value.isInitialized;

  /// Initialize camera safely
  Future<bool> initialize() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        Logger.error("No cameras found.");
        return false;
      }

      final backCamera = _cameras!.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.max, // Highest supported resolution
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg, // High-quality JPEG
      );

      await _controller!.initialize();

      // Read zoom capabilities
      minZoom = await _controller!.getMinZoomLevel();
      maxZoom = await _controller!.getMaxZoomLevel();
      Logger.info("Zoom range: $minZoom → $maxZoom");

      Logger.success("Camera initialized successfully!");
      return true;
    } catch (e, stack) {
      Logger.error("CameraService init error: $e");
      Logger.debug("$stack");
      return false;
    }
  }

  /// Set zoom safely
  Future<void> setZoom(double zoom) async {
    if (!isInitialized) return;
    final safeZoom = zoom.clamp(minZoom, maxZoom);
    try {
      await _controller!.setZoomLevel(safeZoom);
      Logger.debug("Zoom set to: $safeZoom");
    } catch (e) {
      Logger.error("Zoom error: $e");
    }
  }

  /// Capture high-quality photo
  Future<XFile?> capture() async {
    if (!isInitialized) {
      Logger.error("Cannot capture — camera not initialized.");
      return null;
    }

    try {
      final file = await _controller!.takePicture();
      Logger.info("Photo captured: ${file.path}");
      return file;
    } catch (e) {
      Logger.error("Capture failed: $e");
      return null;
    }
  }

  /// Dispose camera safely
  void dispose() {
    try {
      _controller?.dispose();
      _controller = null;
      Logger.info("Camera disposed successfully.");
    } catch (e) {
      Logger.error("Dispose failed: $e");
    }
  }
}
