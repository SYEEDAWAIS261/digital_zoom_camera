import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/camera_service.dart';
import '../../data/camera_repository.dart';
import '../../domain/zoom_controller.dart';
import '../../../core/utils/permissions.dart';
import '../../../shared/widgets/custom_toast.dart';
import 'widgets/zoom_slider.dart';
import 'widgets/capture_button.dart';
import 'widgets/flash_toggle.dart';
import 'overlay.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late final CameraService _cameraService;
  late final CameraRepository _repository;
  late final ZoomController _zoomController;

  static const double hardwareMaxZoom = 10.0; // max hardware zoom

  @override
  void initState() {
    super.initState();
    _cameraService = CameraService();
    _repository = CameraRepository(cameraService: _cameraService);
    _zoomController = ZoomController();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final granted = await Permissions.requestAll();
    if (!granted) {
      if (mounted) CustomToast.show(context, "Camera & Storage permissions required.");
      return;
    }

    await _repository.initializeCamera();
    if (_cameraService.isInitialized) await _cameraService.setZoom(1.0);
    if (mounted) setState(() {});
  }

  double _computeDigitalScale(double zoom) {
    if (zoom <= hardwareMaxZoom) {
      _cameraService.setZoom(zoom);
      return 1.0;
    }
    _cameraService.setZoom(hardwareMaxZoom);
    return (zoom / hardwareMaxZoom).clamp(1.0, 10.0);
  }

  Future<void> _capturePhoto() async {
    final path = await _repository.capturePhoto();
    if (mounted) CustomToast.show(context, path != null ? "Image saved!" : "Capture failed!");
  }

  @override
  void dispose() {
    _repository.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _cameraService.controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return ChangeNotifierProvider.value(
      value: _zoomController,
      child: Scaffold(
        body: Consumer<ZoomController>(
          builder: (_, zoomCtrl, __) {
            final digitalScale = _computeDigitalScale(zoomCtrl.zoom);
            return Stack(
              children: [
                Center(
                  child: Transform.scale(
                    scale: digitalScale,
                    child: CameraPreview(controller),
                  ),
                ),
                const CameraOverlay(),
                Positioned(
                  bottom: 120,
                  left: 20,
                  right: 20,
                  child: const ZoomSlider(),
                ),
              ],
            );
          },
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CaptureButton(onPressed: _capturePhoto),
            const SizedBox(height: 20),
            FlashToggle(
              controller: controller,
              onToggle: () async {
                final newMode = controller.value.flashMode == FlashMode.torch
                    ? FlashMode.off
                    : FlashMode.torch;
                await controller.setFlashMode(newMode);
                if (mounted) setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
