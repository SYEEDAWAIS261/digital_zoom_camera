/// ---------------------------------------------------------------------------
///                       GLOBAL APPLICATION CONSTANTS
/// ---------------------------------------------------------------------------
class AppConstants {
  static const double minZoom = 1.0;
  static const double maxZoom = 100.0; // 100x zoom
  static const double zoomStep = 0.1; // increment for +/– buttons
  static const int zoomDivisions = 200; // slider smoothness

  static const String appName = "Digital Zoom Camera";
  static const String imageFolder = "DigitalZoomImages";
  static const String filePrefix = "DZ_";
  static const String imageFormat = "jpg";
  static const int imageCompressionQuality = 100; // max quality
}
