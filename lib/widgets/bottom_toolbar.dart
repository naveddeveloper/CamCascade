import 'package:camcascade/providers/camera_provider.dart';
import 'package:camcascade/screens/gallery_screen.dart';
import 'package:camcascade/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Widget bottomToolBar(BuildContext context) {
  var cameraProvider = Provider.of<CameraProvider>(context);

  return SafeArea(
    child: Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20.r)),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gallery Icon
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GalleryScreen()));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      width: 50.w,
                      height: 50.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.r),
                          color: Theme.of(context).cardColor),
                      child: Icon(Icons.image,
                          size: 30, color: Theme.of(context).hintColor),
                    ),
                  ),

                  // Video Icon
                  GestureDetector(
                    onTap: () async {
                      var isSaved = await cameraProvider.toggleVideoRecording();
                      if (isSaved) {
                        CustomToast.show(context, "Video saved successfully!");
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      width: 50.w,
                      height: 50.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.r),
                          color: Theme.of(context).cardColor),
                      child: cameraProvider.isVideoRecording
                          ? Icon(Icons.stop,
                              size: 25, color: Theme.of(context).hintColor)
                          : Icon(Icons.videocam,
                              size: 25, color: Theme.of(context).hintColor),
                    ),
                  ),

                  // Take Photo Picture Camera
                  GestureDetector(
                    onTap: () async {
                      bool isSaved = await cameraProvider.takePicture();
                      if (isSaved) {
                        CustomToast.show(context, "Photo saved");
                      } else {
                        CustomToast.show(context, "Photo not saved");
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.r),
                          color: const Color.fromARGB(255, 255, 0, 0)),
                      child: Icon(Icons.camera_alt,
                          size: 40, color: Colors.white),
                    ),
                  ),

                  // Rear Camera or Front Camera Icon
                  GestureDetector(
                    onTap: cameraProvider.switchCamera,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.r),
                          color: Theme.of(context).cardColor),
                      child: cameraProvider.isRearCamera
                          ? Icon(Icons.camera_rear,
                              size: 30, color: Theme.of(context).hintColor)
                          : Icon(Icons.camera_front,
                              size: 30, color: Theme.of(context).hintColor),
                    ),
                  ),

                  // Flash Light Icon
                  GestureDetector(
                    onTap: cameraProvider.toggleFlashLight,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      width: 50.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60.r),
                          color: Theme.of(context).cardColor),
                      child: cameraProvider.isFlashOn
                          ? Icon(Icons.flash_on_outlined,
                              size: 30, color: Theme.of(context).hintColor)
                          : Icon(Icons.flash_off_outlined,
                              size: 30, color: Theme.of(context).hintColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
