import 'package:flutter/foundation.dart';

class Logger {
  static bool enableLogs = kDebugMode; // Auto-off in release mode

  // ANSI Colors
  static const _reset = '\x1B[0m';
  static const _green = '\x1B[32m';
  static const _yellow = '\x1B[33m';
  static const _red = '\x1B[31m';
  static const _cyan = '\x1B[36m';

  static String _timestamp() {
    final now = DateTime.now();
    return "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}:"
        "${now.second.toString().padLeft(2, '0')}";
  }

  /// INFO LOG ────────────────────────────────────────────────
  static void info(String message, {String? tag}) {
    if (!enableLogs) return;
    print(
        "$_green[INFO][${_timestamp()}]${tag != null ? "[$tag]" : ""} $_reset$message");
  }

  /// SUCCESS LOG ─────────────────────────────────────────────
  static void success(String message, {String? tag}) {
    if (!enableLogs) return;
    print(
        "$_green[SUCCESS][${_timestamp()}]${tag != null ? "[$tag]" : ""} $_reset$message");
  }

  /// WARNING LOG ─────────────────────────────────────────────
  static void warning(String message, {String? tag}) {
    if (!enableLogs) return;
    print(
        "$_yellow[WARN][${_timestamp()}]${tag != null ? "[$tag]" : ""} $_reset$message");
  }

  /// ERROR LOG ───────────────────────────────────────────────
  static void error(String message, {String? tag}) {
    if (!enableLogs) return;
    print(
        "$_red[ERROR][${_timestamp()}]${tag != null ? "[$tag]" : ""} $_reset$message");
  }

  /// DEBUG LOG ───────────────────────────────────────────────
  static void debug(String message, {String? tag}) {
    if (!enableLogs) return;
    print(
        "$_cyan[DEBUG][${_timestamp()}]${tag != null ? "[$tag]" : ""} $_reset$message");
  }
}
