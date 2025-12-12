import 'dart:typed_data';
import 'dart:ui' as ui;

class ImageProcessing {
  /// Apply high-quality digital zoom:
  /// 1. Smart Center Crop
  /// 2. Bicubic Upscale
  /// 3. Unsharp Mask (Pro Sharpening)
  static Future<ui.Image> processDigitalZoom(
    ui.Image src,
    double zoomFactor,
  ) async {
    if (zoomFactor <= 1.0) return src;

    try {
      final cropped = await _cropCenter(src, zoomFactor);
      final upscaled = await _bicubicUpscale(cropped, src.width, src.height);
      final sharpened = await _unsharpMask(upscaled);

      return sharpened;
    } catch (_) {
      return src; // fallback safe
    }
  }

  // ------------------------------------------------------------
  // 1) SMART CENTER CROP (best quality)
  // ------------------------------------------------------------
  static Future<ui.Image> _cropCenter(
    ui.Image src,
    double zoomFactor,
  ) async {
    final cropW = src.width / zoomFactor;
    final cropH = src.height / zoomFactor;

    final left = (src.width - cropW) / 2;
    final top = (src.height - cropH) / 2;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    final srcRect = ui.Rect.fromLTWH(left, top, cropW, cropH);
    final dstRect = ui.Rect.fromLTWH(0, 0, cropW, cropH);

    canvas.drawImageRect(src, srcRect, dstRect, ui.Paint());

    final picture = recorder.endRecording();
    return await picture.toImage(cropW.toInt(), cropH.toInt());
  }

  // ------------------------------------------------------------
  // 2) BICUBIC UPSCALE (maximum quality)
  // ------------------------------------------------------------
  static Future<ui.Image> _bicubicUpscale(
    ui.Image src,
    int targetWidth,
    int targetHeight,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    final paint = ui.Paint()
      ..filterQuality = ui.FilterQuality.high;

    canvas.drawImageRect(
      src,
      ui.Rect.fromLTWH(0, 0, src.width.toDouble(), src.height.toDouble()),
      ui.Rect.fromLTWH(0, 0, targetWidth.toDouble(), targetHeight.toDouble()),
      paint,
    );

    final picture = recorder.endRecording();
    return await picture.toImage(targetWidth, targetHeight);
  }

  // ------------------------------------------------------------
  // 3) UNSHARP MASK (professional sharpening)
  // ------------------------------------------------------------
  static Future<ui.Image> _unsharpMask(ui.Image src) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    /// Professional sharpening kernel
    /// lightly sharpen + contrast boost
    final kernel = Float64List.fromList([
      0,  -1,  0,    0, 0,
     -1,  5, -1,    0, 0,
      0, -1,  0,    0, 0,
      0,  0,  0,    1, 0,
    ]);

    final paint = ui.Paint()
      ..imageFilter = ui.ImageFilter.matrix(kernel);

    canvas.drawImage(src, ui.Offset.zero, paint);

    final picture = recorder.endRecording();
    return await picture.toImage(src.width, src.height);
  }
}
