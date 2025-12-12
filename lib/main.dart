import 'package:flutter/material.dart';
import 'package:digital_zoom_camera/app/routes.dart';
import 'package:digital_zoom_camera/app/themes.dart';
import 'package:digital_zoom_camera/app/constants.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: Initialize any services here (camera, permissions, storage, etc.)
  // Example: await Permissions.checkAll();

  runApp(const DigitalZoomCameraApp());
}

class DigitalZoomCameraApp extends StatelessWidget {
  const DigitalZoomCameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Use system theme mode automatically
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,

      // Routing
      initialRoute: Routes.cameraScreen,
      routes: Routes.getRoutes(),

      // Optional: Global error handling, localization, etc.
      builder: (context, child) {
        return SafeArea(child: child!);
      },
    );
  }
}
