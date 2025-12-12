import 'package:flutter/material.dart';

class CameraOverlay extends StatelessWidget {
  final double borderWidth;
  final Color borderColor;
  final double cornerSize;
  final double overlayOpacity;

  const CameraOverlay({
    super.key,
    this.borderWidth = 2,
    this.borderColor = Colors.white,
    this.cornerSize = 30,
    this.overlayOpacity = 0.35,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          // ====== Background Dark Overlay with Gradient Fade ======
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(overlayOpacity),
                  Colors.transparent,
                  Colors.black.withOpacity(overlayOpacity),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ====== Full White Border ======
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor.withOpacity(0.7),
                width: borderWidth,
              ),
            ),
          ),

          // ====== Corner Borders (Premium look) ======
          _buildCornerBorders(),
        ],
      ),
    );
  }

  Widget _buildCornerBorders() {
    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: CustomPaint(
          painter: _CornersPainter(
            cornerSize: cornerSize,
            color: borderColor,
            strokeWidth: borderWidth,
          ),
        ),
      ),
    );
  }
}

class _CornersPainter extends CustomPainter {
  final double cornerSize;
  final Color color;
  final double strokeWidth;

  _CornersPainter({
    required this.cornerSize,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Top Left corner
    canvas.drawLine(Offset(0, 0), Offset(cornerSize, 0), paint);
    canvas.drawLine(Offset(0, 0), Offset(0, cornerSize), paint);

    // Top Right corner
    canvas.drawLine(Offset(size.width, 0),
        Offset(size.width - cornerSize, 0), paint);
    canvas.drawLine(Offset(size.width, 0),
        Offset(size.width, cornerSize), paint);

    // Bottom Left corner
    canvas.drawLine(Offset(0, size.height),
        Offset(0, size.height - cornerSize), paint);
    canvas.drawLine(Offset(0, size.height),
        Offset(cornerSize, size.height), paint);

    // Bottom Right corner
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - cornerSize, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - cornerSize),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
