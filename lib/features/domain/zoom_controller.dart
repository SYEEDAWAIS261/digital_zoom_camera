import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../app/constants.dart';

class ZoomController extends ChangeNotifier {
  double _zoom = AppConstants.minZoom;
  double get zoom => _zoom;

  final Duration animationDuration;
  final int animationSteps;
  bool _isAnimating = false;
  Timer? _throttleTimer;

  ZoomController({
    this.animationDuration = const Duration(milliseconds: 120),
    this.animationSteps = 12,
  });

  void setZoom(double value, {bool smooth = false}) {
    final newValue = value.clamp(AppConstants.minZoom, AppConstants.maxZoom);
    if (smooth) {
      _animateZoom(_zoom, newValue);
    } else {
      _zoom = newValue;
      _notifySafe();
    }
  }

  void _animateZoom(double from, double to) async {
    if (_isAnimating) return;
    _isAnimating = true;

    for (int i = 0; i <= animationSteps; i++) {
      final t = i / animationSteps;
      _zoom = lerpDouble(from, to, t)!;
      _notifySafe();
      await Future.delayed(animationDuration ~/ animationSteps);
    }

    _isAnimating = false;
  }

  void setZoomThrottled(double value) {
    final newValue = value.clamp(AppConstants.minZoom, AppConstants.maxZoom);
    if (_throttleTimer?.isActive ?? false) return;

    _throttleTimer = Timer(const Duration(milliseconds: 16), () {
      _zoom = newValue;
      _notifySafe();
    });
  }

  void increment({double step = AppConstants.zoomStep}) {
    setZoom(_zoom + step, smooth: true);
  }

  void decrement({double step = AppConstants.zoomStep}) {
    setZoom(_zoom - step, smooth: true);
  }

  void _notifySafe() {
    if (hasListeners) notifyListeners();
  }

  @override
  void dispose() {
    _throttleTimer?.cancel();
    super.dispose();
  }
}
