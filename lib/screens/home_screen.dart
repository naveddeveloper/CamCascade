import 'dart:typed_data';
import 'package:camcascade/providers/camera_provider.dart';
import 'package:camcascade/utils/sound_manager.dart';
import 'package:camcascade/widgets/custom_toast.dart';
import 'package:camcascade/widgets/topleft_bar.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camcascade/widgets/bottom_toolbar.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:camcascade/widgets/recording_time.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // HomeScreen States
  double _currentZoom = 1.0; // Default zoom level
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  final double _zoomStep = 1.5; // How much zoom increases per tap

  bool isQrScannerActive = false; // Toggle between camera and scanner

  // A scanner initialize
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: true,
  );

  @override
  void initState() {
    super.initState();
    // initalize the cameraProvider to show the camera in my screen
    Future.microtask(() {
      Provider.of<CameraProvider>(context, listen: false).initCamera();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cameraProvider = Provider.of<CameraProvider>(context, listen: false);

    if (cameraProvider.isInitialized && _maxZoom == 1.0) {
      _initializeZoomLevels(cameraProvider.controller!);
    }
  }

  Future<void> _initializeZoomLevels(CameraController controller) async {
    if (!controller.value.isInitialized) return;

    final double minZoom = await controller.getMinZoomLevel();
    final double maxZoom = await controller.getMaxZoomLevel();
    final double currentZoom = 1.0;

    setState(() {
      _minZoom = minZoom;
      _maxZoom = maxZoom;
      _currentZoom = currentZoom;
    });
  }

  // Set the zoom level
  Future<void> _setZoomLevel(double zoom, CameraController controller) async {
    if (zoom >= _minZoom && zoom <= _maxZoom) {
      await controller.setZoomLevel(zoom);
      setState(() {
        _currentZoom = zoom;
      });
    }
  }

  // Handle tap listeners
  void _handleTapToZoom(CameraController controller) {
    double newZoom = (_currentZoom * _zoomStep).clamp(_minZoom, _maxZoom);
    _setZoomLevel(newZoom, controller);
  }

  // Handle double tap to reset the zoom level
  void _handleDoubleTapToReset(CameraController controller) {
    _setZoomLevel(_minZoom, controller);
  }

  // Toggle the scanner if it isQrScannerActive then change it to isQrScannerActive: false
  Future<void> toggleScanner() async {
    setState(() {
      isQrScannerActive = !isQrScannerActive;
    });

    final cameraProvider = Provider.of<CameraProvider>(context, listen: false);
    if (isQrScannerActive) {
      cameraProvider.disposeCamera(); // Properly dispose of the camera
    } else {
      await cameraProvider.initCamera(); // Wait until the camera initializes
      setState(() {}); // Rebuild UI after camera initialization
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<CameraProvider>(
      builder: (context, cameraProvider, child) {
        return Scaffold(
          body: Stack(
            children: [
              // If the qr code is active then show the qr code
              isQrScannerActive
                  ? MobileScanner(
                      controller: _scannerController,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        final Uint8List? image = capture.image;
                        SoundManager.playSound("audio/clicked.mp3");

                        if (barcodes.isNotEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Theme.of(context).primaryColor,
                                title: Text(
                                  barcodes.first.rawValue ?? "No data",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      color: Theme.of(context).cardColor),
                                ),
                                content: image != null
                                    ? Image(image: MemoryImage(image))
                                    : null,
                                actions: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      var url =
                                          Uri.parse(barcodes.first.rawValue!);
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url,
                                            mode:
                                                LaunchMode.externalApplication);
                                      } else {
                                        CustomToast.show(
                                            context, "Could not launch $url");
                                        throw "Could not launch $url";
                                      }
                                    },
                                    child: Text('Open Link',
                                        style: TextStyle(
                                            color: Theme.of(context).cardColor,
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    )
                  : (cameraProvider.isInitialized &&
                          cameraProvider.controller != null
                      ? GestureDetector(
                          onScaleUpdate: (ScaleUpdateDetails details) {
                            double newZoom = (_currentZoom * details.scale)
                                .clamp(_minZoom, _maxZoom);
                            _setZoomLevel(newZoom, cameraProvider.controller!);
                          },
                          onTap: () =>
                              _handleTapToZoom(cameraProvider.controller!),
                          onDoubleTap: () => _handleDoubleTapToReset(
                              cameraProvider.controller!),
                          child: SizedBox(
                            width: size.width,
                            height: size.height,
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: 100.w,
                                child:
                                    CameraPreview(cameraProvider.controller!),
                              ),
                            ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator())),

              // Bottom ToolBar
              if (!isQrScannerActive) bottomToolBar(context),

              // Top Left Bar
              topLeftBar(context, toggleScanner, isQrScannerActive),

              // Zoom Slider
              if (!isQrScannerActive &&
                  cameraProvider.isInitialized &&
                  _maxZoom > _minZoom)
                Positioned(
                  bottom: 80.h,
                  left: 20.w,
                  right: 20.w,
                  child: cameraProvider.isInitialized
                      ? Padding(
                          padding: EdgeInsets.all(8.0.w),
                          child: Slider(
                            thumbColor: Theme.of(context).cardColor,
                            overlayColor: WidgetStatePropertyAll(Colors.red),
                            value: _currentZoom,
                            min: _minZoom,
                            max: _maxZoom,
                            onChanged: (value) => _setZoomLevel(
                                value, cameraProvider.controller!),
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                          ),
                        )
                      : const SizedBox(),
                ),

              cameraProvider.isVideoRecording
                  ? RecordingTimeDisplay(cameraProvider: cameraProvider)
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}
