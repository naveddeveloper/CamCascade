import 'dart:io';
import 'package:camcascade/providers/camera_provider.dart';
import 'package:camcascade/utils/sound_manager.dart';
import 'package:camcascade/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:camcascade/widgets/dialog_details.dart';
import 'package:video_player/video_player.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // Variables
  int currentIndex = 0;
  VideoPlayerController? _videoController;
  bool isPlaying = false;
  bool isVideoLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cameraProvider =
          Provider.of<CameraProvider>(context, listen: false);
      if (cameraProvider.dataList.isNotEmpty) {
        String firstFilePath = cameraProvider.dataList[0].path;
        if (firstFilePath.toLowerCase().endsWith(".mp4")) {
          Future.microtask(() => _initializeVideo(firstFilePath));
        }
      }
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  // A method to initalize the video controller
  Future<void> _initializeVideo(String videoPath) async {
    setState(() {
      isVideoLoading = true;
      isPlaying = false;
    });

    try {
      if (_videoController != null) {
        await _videoController!.dispose();
        _videoController = null;
      }

      if (!File(videoPath).existsSync()) {
        CustomToast.show(context, "Video not found");
        setState(() => isVideoLoading = false);
        return;
      }

      _videoController = VideoPlayerController.file(File(videoPath))
        ..initialize().then((_) {
          setState(() {
            isVideoLoading = false;
            isPlaying = true;
          });
          _videoController!.setLooping(true);
          _videoController!.play();
        });
    } catch (e) {
      debugPrint("Error initializing video: $e");
      setState(() => isVideoLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraProvider = Provider.of<CameraProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Camera Gallery",
          style: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              fontSize: 24.sp),
        ),
      ),
      body: cameraProvider.dataList.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                        String currentPath =
                            cameraProvider.dataList[currentIndex].path;
                        if (currentPath.toLowerCase().endsWith(".mp4")) {
                          _initializeVideo(currentPath);
                        } else {
                          _videoController?.dispose();
                          _videoController = null;
                        }
                      });
                    },
                    itemCount: cameraProvider.dataList.length,
                    itemBuilder: (context, index) {
                      String filePath = cameraProvider.dataList[index].path;
                      bool isVideo = filePath.toLowerCase().endsWith(".mp4");

                      if (isVideo && index == currentIndex) {
                        return _buildVideoPlayer(filePath);
                      } else {
                        return PhotoView(
                          imageProvider: FileImage(File(filePath)),
                          minScale: PhotoViewComputedScale.contained,
                          maxScale: PhotoViewComputedScale.covered * 3,
                        );
                      }
                    },
                  ),
                ),
                _buildBottomBar(cameraProvider),
              ],
            )
          : Center(
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Please capture some images/videos",
                  style: TextStyle(
                      fontSize: 30.sp,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }

  Widget _buildVideoPlayer(videoPath) {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Transform.rotate(
      angle: _getRotationAngle(),
      child: AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: VideoPlayer(_videoController!),
      ),
    );
  }

  double _getRotationAngle() {
    int? rotation = _videoController?.value.rotationCorrection;
    switch (rotation) {
      case 90:
        return -90 * (3.1415927 / 180);
      case 180:
        return -180 * (3.1415927 / 180);
      case 270:
        return -270 * (3.1415927 / 180);
      default:
        return 0.0;
    }
  }

  Widget _buildBottomBar(CameraProvider cameraProvider) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIcon(Icons.share, () async {
            XFile fileToShare =
                XFile(cameraProvider.dataList[currentIndex].path);
            await Share.shareXFiles([fileToShare]);
          }),
          _buildIcon(Icons.delete, () {
            SoundManager.playSound("audio/trash.mp3");
            cameraProvider.dataList[currentIndex].delete(recursive: true);
            cameraProvider.dataList.removeAt(currentIndex);
            CustomToast.show(context, "Deleted successfully!");
            setState(() {
              if (cameraProvider.dataList.isNotEmpty) {
                currentIndex =
                    currentIndex.clamp(0, cameraProvider.dataList.length - 1);
                String currentPath = cameraProvider.dataList[currentIndex].path;
                if (currentPath.toLowerCase().endsWith(".mp4")) {
                  _initializeVideo(currentPath);
                } else {
                  _videoController?.dispose();
                  _videoController = null;
                }
              }
            });
          }),
          _buildIcon(Icons.info, () {
            dialogBuilder(context, cameraProvider.dataList[currentIndex]);
          }),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        width: 40.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor,
          borderRadius: BorderRadius.circular(60.r),
        ),
        child: Icon(
          icon,
          size: 25,
          color: Theme.of(context).cardColor,
        ),
      ),
    );
  }
}
