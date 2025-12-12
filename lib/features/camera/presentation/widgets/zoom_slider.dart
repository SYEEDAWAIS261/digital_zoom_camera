import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../domain/zoom_controller.dart';
import '../../../../app/constants.dart';
import 'package:flutter/services.dart';

class ZoomSlider extends StatelessWidget {
  const ZoomSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<ZoomController, double>(
      selector: (_, controller) => controller.zoom,
      builder: (context, zoom, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, size: 20, color: Colors.white),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.read<ZoomController>().decrement();
                },
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 4,
                    activeTrackColor: Colors.blueAccent,
                    inactiveTrackColor: Colors.white24,
                    thumbColor: Colors.blueAccent,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                    overlayColor: Colors.blueAccent.withOpacity(0.2),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
                  ),
                  child: Slider(
                    value: zoom,
                    min: AppConstants.minZoom,
                    max: AppConstants.maxZoom,
                    divisions: AppConstants.zoomDivisions,
                    label: "${zoom.toStringAsFixed(1)}x",
                    onChanged: (value) {
                      HapticFeedback.selectionClick();
                      context.read<ZoomController>().setZoom(value);
                    },
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, size: 20, color: Colors.white),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  context.read<ZoomController>().increment();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  "${zoom.toStringAsFixed(1)}x",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
