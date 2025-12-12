import 'package:flutter/material.dart';

/// A lightweight, customizable toast message overlay.
class CustomToast {
  static OverlayEntry? _currentOverlay;

  /// Show a toast message at the bottom of the screen.
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    double bottomOffset = 50,
    Color backgroundColor = const Color(0xCC000000),
    Color textColor = Colors.white,
    double borderRadius = 8,
    double fontSize = 14,
  }) {
    // Remove existing toast if present
    _currentOverlay?.remove();
    _currentOverlay = null;

    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        bottomOffset: bottomOffset,
        backgroundColor: backgroundColor,
        textColor: textColor,
        borderRadius: borderRadius,
        fontSize: fontSize,
      ),
    );

    _currentOverlay = overlayEntry;
    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      _currentOverlay?.remove();
      _currentOverlay = null;
    });
  }
}

/// Internal widget for toast with fade animation
class _ToastWidget extends StatefulWidget {
  final String message;
  final double bottomOffset;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double fontSize;

  const _ToastWidget({
    required this.message,
    required this.bottomOffset,
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
    required this.fontSize,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: widget.bottomOffset,
      left: 20,
      right: 20,
      child: FadeTransition(
        opacity: _opacity,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Text(
              widget.message,
              style:
                  TextStyle(color: widget.textColor, fontSize: widget.fontSize),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
