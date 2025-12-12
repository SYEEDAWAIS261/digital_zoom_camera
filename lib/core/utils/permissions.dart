import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class Permissions {
  /// ---------------------------------------------------------
  /// PUBLIC : Check if all permissions are granted (without requesting)
  /// ---------------------------------------------------------
  static Future<bool> checkAll() async {
    final List<Permission> required = await _getPlatformPermissions();

    // Check status of all permissions
    for (final perm in required) {
      final status = await perm.status;
      if (!status.isGranted) return false;
    }

    return true;
  }

  /// ---------------------------------------------------------
  /// PUBLIC : Request permissions (camera + storage)
  /// ---------------------------------------------------------
  static Future<bool> requestAll() async {
    final List<Permission> required = await _getPlatformPermissions();

    // Request all at once
    final statuses = await required.request();

    // Return TRUE if *all* permissions granted
    return statuses.values.every((s) => s.isGranted);
  }

  /// ---------------------------------------------------------
  /// PUBLIC : Show popup when permissions permanently denied
  /// ---------------------------------------------------------
  static Future<void> showDeniedDialog(BuildContext context) async {
    if (!await _isAnyPermanentlyDenied()) return;

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Permissions Required"),
        content: const Text(
            "Your camera or storage access is permanently denied.\n\n"
            "You must allow permissions from settings to use this app."),
        actions: [
          TextButton(
            onPressed: () => openAppSettings(),
            child: const Text("Open Settings"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  /// ---------------------------------------------------------
  /// PRIVATE : Decide which permissions required based on SDK
  /// ---------------------------------------------------------
  static Future<List<Permission>> _getPlatformPermissions() async {
    List<Permission> list = [Permission.camera];

    if (!Platform.isAndroid) return list;

    final int sdk = await _getAndroidSdkInt();

    if (sdk >= 33) {
      // ANDROID 13+
      list.add(Permission.photos); // Scoped storage
    } else {
      // Android 6–12
      list.add(Permission.storage);
    }

    return list;
  }

  /// ---------------------------------------------------------
  /// PRIVATE : Get Android SDK version
  /// ---------------------------------------------------------
  static Future<int> _getAndroidSdkInt() async {
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      return info.version.sdkInt;
    } catch (_) {
      return 0; // fallback
    }
  }

  /// ---------------------------------------------------------
  /// PRIVATE : Check if ANY required permission is permanently denied
  /// ---------------------------------------------------------
  static Future<bool> _isAnyPermanentlyDenied() async {
    final required = await _getPlatformPermissions();
    for (final perm in required) {
      final status = await perm.status;
      if (status.isPermanentlyDenied) return true;
    }
    return false;
  }
}
