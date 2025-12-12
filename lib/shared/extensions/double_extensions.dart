/// Extension methods on `double` to handle zoom-related calculations
extension ZoomExtensions on double {
  /// Clamp zoom value between [min] and [max] inclusively
  double clampZoom(double min, double max) => this < min
      ? min
      : this > max
          ? max
          : this;

  /// Convert zoom value to a readable string with 1 decimal place (e.g., 2.5×)
  String toZoomString({int decimals = 1}) => "${toStringAsFixed(decimals)}×";

  /// Convert zoom value to percentage (e.g., 2.0 → 200%)
  String toZoomPercentage({int decimals = 0}) =>
      "${(this * 100).toStringAsFixed(decimals)}%";

  /// Check if the zoom is effectively "no zoom" (1x)
  bool get isDefaultZoom => this <= 1.0;
}
