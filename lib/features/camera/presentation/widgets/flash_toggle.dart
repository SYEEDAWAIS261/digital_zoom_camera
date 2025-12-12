import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class FlashToggle extends StatelessWidget {
  final CameraController controller;
  final VoidCallback onToggle;

  const FlashToggle({
    super.key,
    required this.controller,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isFlashOn = controller.value.flashMode == FlashMode.torch;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: isFlashOn ? Colors.yellowAccent.withOpacity(0.9) : Colors.black45,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: isFlashOn ? Colors.yellowAccent.withOpacity(0.5) : Colors.black26,
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: IconButton(
        tooltip: isFlashOn ? "Flash On" : "Flash Off",
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, anim) => RotationTransition(
            turns: child.key == const ValueKey('flashOn')
                ? Tween<double>(begin: 0.5, end: 1.0).animate(anim)
                : Tween<double>(begin: 1.0, end: 0.5).animate(anim),
            child: FadeTransition(opacity: anim, child: child),
          ),
          child: Icon(
            isFlashOn ? Icons.flash_on : Icons.flash_off,
            key: ValueKey(isFlashOn ? 'flashOn' : 'flashOff'),
            color: isFlashOn ? Colors.black : Colors.white,
          ),
        ),
        onPressed: onToggle,
      ),
    );
  }
}
