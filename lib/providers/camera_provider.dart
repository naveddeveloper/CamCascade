import 'dart:async';
import 'dart:io';
import 'package:camcascade/utils/get_filepath_uri.dart';
import 'package:camcascade/utils/sound_manager.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class CameraProvider extends ChangeNotifier {
  // Variables
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  List<File> dataList = [];

  bool isRearCamera = true;
  bool isFlashOn = false;
  bool isLockedFocus = false;
  bool isVideoRecording = false;

  Stopwatch stopwatch = Stopwatch();
  Timer? _stopwatchTimer;

  ResolutionPreset _resolutionPreset = ResolutionPreset.max;
  FlashMode _flashMode = FlashMode.off;
  FocusMode _focusMode = FocusMode.auto;
  ExposureMode _exposureMode = ExposureMode.auto;

  // Getters
  CameraController? get controller => _controller;
  ResolutionPreset get resolutionPreset => _resolutionPreset;
  bool get isInitialized => _isInitialized;
  FlashMode get flashMode => _flashMode;
  FocusMode get focusMode => _focusMode;
  ExposureMode get exposureMode => _exposureMode;

  // Use ValueNotifier to update only the recording time text
  final ValueNotifier<String> recordingTimeNotifier = ValueNotifier("00:00:00");

  // Initialize the camera _controller
  Future<void> initCamera([ResolutionPreset? preset]) async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        throw CameraException('NoCamera', 'No cameras available');
      }

      _controller = CameraController(
        _cameras[isRearCamera ? 0 : 1],
        preset ?? _resolutionPreset,
      );

      if (_controller == null) {
        throw CameraException("Null Controller", "Camera controller is null");
      }

      await _controller!.initialize();

      if (isFlashOn) {
        _controller!.setFlashMode(FlashMode.torch);
      }
      if (isLockedFocus) {
        _controller!.setFocusMode(FocusMode.locked);
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initCamera :: CameraProvider $e');
    }
  }

  // Toggle video recording
  Future<bool> toggleVideoRecording() async {
    try {
      isVideoRecording = !isVideoRecording;
      if (isVideoRecording) {
        startVideoRecording();
      } else {
        var isSaved = await stopVideoRecording();
        return isSaved;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error toggleVideoRecording :: CameraProvider $e");
    }
    return false;
  }

  // Toggle Flash Light Mode
  Future<void> toggleFlashLight() async {
    try {
      isFlashOn = !isFlashOn;
      if (isFlashOn) {
        _controller!.setFlashMode(FlashMode.torch);
      } else {
        _controller!.setFlashMode(FlashMode.off);
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error toggleFlashMode :: CameraProvider $e");
    }
  }

  // Toggle Focus Mode
  Future<void> toggleFocusMode() async {
    try {
      isLockedFocus = !isLockedFocus;
      if (isLockedFocus) {
        _controller!.setFocusMode(FocusMode.locked);
      } else {
        _controller!.setFocusMode(FocusMode.auto);
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error toggleFocusMode :: CameraProvider $e");
    }
  }

  // Switch the camera if isRearCamera is true then show the rear camera or else front camera
  Future<void> switchCamera() async {
    try {
      if (_cameras.isNotEmpty && _controller != null) {
        final newCamera = _cameras.firstWhere(
          (camera) =>
              camera.lensDirection != _controller!.description.lensDirection,
          orElse: () => _cameras[0],
        );

        if (newCamera.lensDirection == CameraLensDirection.back) {
          isRearCamera = true;
        } else {
          isRearCamera = false;
        }

        _controller =
            CameraController(newCamera, _resolutionPreset, enableAudio: true);
        await _controller!.initialize();
        if (isFlashOn) {
          _controller!.setFlashMode(FlashMode.torch);
        }
        if (isLockedFocus) {
          _controller!.setFocusMode(FocusMode.locked);
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error switchCamera :: CameraProvider $e");
    }
  }

  // A function for taking a picture
  Future<bool> takePicture() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        XFile image = await _controller!.takePicture();
        SoundManager.playSound("audio/clicked.mp3");
        File? savedFile = await saveImage(image);

        if (savedFile == null || savedFile.path.isEmpty) {
          debugPrint("Not saved image savedfile is null or empty");
          return false;
        }

        dataList.add(savedFile);

        if (isFlashOn) {
          _controller!.setFlashMode(FlashMode.off);
          isFlashOn = false;
          notifyListeners();
        }

        return true;
      } catch (e) {
        debugPrint("Error takePicture :: CameraProvider $e");
        return false;
      }
    } else {
      return false;
    }
  }

  Future<File?> saveImage(XFile image) async {
    try {
      // Check permission for storage
      var status = await Permission.storage.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        debugPrint("Permission denied");
        openAppSettings();
        return null;
      }

      final result = await ImageGallerySaverPlus.saveImage(
          await image.readAsBytes(),
          quality: 100);

      debugPrint("Image saved to gallery");

      if (result['isSuccess'] == true) {
        String filePath =
            result['filePath'].toString().replaceAll("file://", "");
        debugPrint("Image saved successfully: $filePath");

        if (filePath.contains("content://")) {
          String? filePath2 = await getFilePathFromContentUri(filePath);
          return File(filePath2!);
        } else {
          return File(filePath);
        }
      } else {
        debugPrint("Failed to save image");
      }
    } catch (e) {
      debugPrint("Error saving image: $e");
    }
    return null;
  }

  Future<File?> saveVideo(XFile video) async {
    try {
      // Check permission for storage
      var status = await Permission.storage.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        debugPrint("Permission denied");
        openAppSettings();
        return null;
      }

      // Convert XFile to File
      File videoFile = File(video.path);

      // Save image to gallery using GallerySaver
      final result = await ImageGallerySaverPlus.saveFile(videoFile.path);

      debugPrint("Video saved to gallery: $result");

      if (result['isSuccess'] == true) {
        String filePath =
            result['filePath'].toString().replaceAll("file://", "");
        debugPrint("Video saved successfully: $filePath");

        if (filePath.contains("content://")) {
          String? filePath2 = await getFilePathFromContentUri(filePath);
          return File(filePath2!);
        } else {
          return File(filePath);
        }
      } else {
        debugPrint("Failed to save image");
      }
    } catch (e) {
      debugPrint("Error saving video: $e");
    }
    return null;
  }

  Future<void> startVideoRecording() async {
    try {
      if (!(_controller!.value.isInitialized) ||
          !(_controller!.value.isRecordingVideo)) {
        SoundManager.playSound("audio/videostart.mp3");
        if (!isFlashOn) {
          _controller!.setFlashMode(FlashMode.off);
        } else {
          _controller!.setFlashMode(FlashMode.torch);
        }
        await _controller!.startVideoRecording();
        isVideoRecording = true;
        stopwatch.start();

        // Start a periodic timer to update the stopwatch display
        _stopwatchTimer = Timer.periodic(Duration(milliseconds: 30), (timer) {
          recordingTimeNotifier.value = returnFormattedText();
        });
      }
    } catch (e) {
      debugPrint("ERROR startVideoRecording :: CameraProvider $e");
    } finally {
      notifyListeners();
    }
  }

  String returnFormattedText() {
    int seconds = (stopwatch.elapsedMilliseconds ~/ 1000) % 60;
    int minutes = (stopwatch.elapsedMilliseconds ~/ 60000) % 60;
    int millis = (stopwatch.elapsedMilliseconds ~/ 10) % 100;
    return "$minutes:${seconds.toString().padLeft(2, '0')}:$millis";
  }

  Future<bool> stopVideoRecording() async {
    try {
      if (!(_controller!.value.isInitialized) ||
          (_controller!.value.isRecordingVideo)) {
        XFile? video;
        stopwatch.stop();
        _stopwatchTimer?.cancel();
        stopwatch.reset();
        isVideoRecording = false;

        // Cancel the stopwatch timer if it exists
        _stopwatchTimer?.cancel();
        _stopwatchTimer = null;

        video = await _controller!.stopVideoRecording();
        if (_controller!.value.flashMode == FlashMode.torch) {
          _controller!.setFlashMode(FlashMode.off);
        }

        File? file = await saveVideo(video);
        if (file == null || file.path.isEmpty) {
          debugPrint("Not saved image savedfile is null or empty");
          return false;
        }
        SoundManager.playSound("audio/videoend.mp3");
        dataList.add(file);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("ERROR stopVideoRecording :: CameraProvider $e");
      return false;
    } finally {
      notifyListeners();
    }
  }

  // Setting Screen Change methods
  // Change Resolution
  Future<void> changeResolution(ResolutionPreset preset) async {
    _resolutionPreset = preset;
    _isInitialized = false;
    notifyListeners();
    await initCamera(preset);
  }

  // Change Flash Mode
  Future<void> changeFlashMode(FlashMode mode) async {
    _flashMode = mode;
    if (_controller != null) {
      await _controller!.setFlashMode(mode);
    }
    notifyListeners();
  }

  // Change Focus Mode
  Future<void> changeFocusMode(FocusMode mode) async {
    _focusMode = mode;
    if (_focusMode == FocusMode.locked) {
      isLockedFocus = true;
    } else {
      isLockedFocus = false;
    }
    if (_controller != null) {
      await _controller!.setFocusMode(mode);
    }
    notifyListeners();
  }

  // Change Exposure Mode
  Future<void> changeExposureMode(ExposureMode mode) async {
    _exposureMode = mode;
    if (_controller != null) {
      await _controller!.setExposureMode(mode);
    }
    notifyListeners();
  }

  void disposeCamera() {
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
    _stopwatchTimer?.cancel();
    recordingTimeNotifier.dispose();
    notifyListeners();
  }

  @override
  void dispose() {
    disposeCamera();
    super.dispose();
  }
}