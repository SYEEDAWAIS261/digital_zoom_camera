import 'package:flutter/material.dart';
import 'package:digital_zoom_camera/features/camera/presentation/camera_screen.dart';

class Routes {
  static const String cameraScreen = '/camera';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      cameraScreen: (context) => const CameraScreen(),
    };
  }
}
