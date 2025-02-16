import 'package:camcascade/providers/camera_provider.dart';
import 'package:camcascade/widgets/row_bar_setting.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {

    return Consumer<CameraProvider>(
      builder: (context, cameraProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Camera Settings",
              style: TextStyle(
                  fontSize: 24.sp,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black),
            ),
          ),
          body: SingleChildScrollView(
              child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            // Camera Quality
                            rowBarSetting(context, "Camera Quality", [
                              DropdownMenuItem(
                                  value: ResolutionPreset.high,
                                  child: Text(
                                    "720P",
                                    style: TextStyle(
                                        color: Theme.of(context).cardColor),
                                  )),
                              DropdownMenuItem(
                                  value: ResolutionPreset.max,
                                  child: Text("Highest",
                                      style: TextStyle(
                                          color: Theme.of(context).cardColor))),
                              DropdownMenuItem(
                                  value: ResolutionPreset.low,
                                  child: Text("240P",
                                      style: TextStyle(
                                          color: Theme.of(context).cardColor))),
                              DropdownMenuItem(
                                  value: ResolutionPreset.medium,
                                  child: Text("480P",
                                      style: TextStyle(
                                          color: Theme.of(context).cardColor))),
                              DropdownMenuItem(
                                  value: ResolutionPreset.ultraHigh,
                                  child: Text("2160P",
                                      style: TextStyle(
                                          color: Theme.of(context).cardColor))),
                              DropdownMenuItem(
                                  value: ResolutionPreset.veryHigh,
                                  child: Text("1080P",
                                      style: TextStyle(
                                          color: Theme.of(context).cardColor))),
                            ], (value) {
                              cameraProvider.changeResolution(value);
                            },
                                cameraProvider.controller!.resolutionPreset
                                    .toString()),

                            // Focus Mode
                            rowBarSetting(context, "Focus Mode", [
                              DropdownMenuItem(
                                  value: FocusMode.auto,
                                  child: Text(
                                    "Auto",
                                    style: TextStyle(
                                        color: Theme.of(context).cardColor),
                                  )),
                              DropdownMenuItem(
                                  value: FocusMode.locked,
                                  child: Text(
                                    "Locked",
                                    style: TextStyle(
                                        color: Theme.of(context).cardColor),
                                  )),
                            ], (value) {
                              cameraProvider.changeFocusMode(value);
                            },
                                cameraProvider.controller!.value.focusMode
                                    .toString()),

                            // Flash Mode
                            rowBarSetting(context, "Flash Mode", [
                              DropdownMenuItem(
                                  value: FlashMode.auto,
                                  child: Text(
                                    "Auto",
                                    style: TextStyle(
                                        color: Theme.of(context).cardColor),
                                  )),
                              DropdownMenuItem(
                                  value: FlashMode.off,
                                  child: Text(
                                    "Off",
                                    style: TextStyle(
                                        color: Theme.of(context).cardColor),
                                  )),
                              DropdownMenuItem(
                                  value: FlashMode.torch,
                                  child: Text(
                                    "Torch",
                                    style: TextStyle(
                                        color: Theme.of(context).cardColor),
                                  )),
                              DropdownMenuItem(
                                  value: FlashMode.always,
                                  child: Text(
                                    "Always",
                                    style: TextStyle(
                                        color: Theme.of(context).cardColor),
                                  )),
                            ], (value) {
                              cameraProvider.changeFlashMode(value);
                            },
                                cameraProvider.controller!.value.flashMode
                                    .toString()),

                            // Exposure Mode
                            rowBarSetting(context, "Exposure Mode", [
                              DropdownMenuItem(
                                  value: ExposureMode.auto,
                                  child: Text(
                                    "Auto",
                                    style: TextStyle(
                                        color: Theme.of(context).cardColor),
                                  )),
                              DropdownMenuItem(
                                  value: ExposureMode.locked,
                                  child: Text(
                                    "Locked",
                                    style: TextStyle(
                                        color: Theme.of(context).cardColor),
                                  )),
                            ], (value) {
                              cameraProvider.changeExposureMode(value);
                            },
                                cameraProvider.controller!.value.exposureMode
                                    .toString()),
                          ],
                        ),

                        // Developer information box
                        GestureDetector(
                          onTap: () async {
                            await launchUrl(Uri.parse(
                                "https://github.com/naveddeveloper/camcascade"));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.circular(12.r)),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.w, vertical: 15.h),
                                child: Text(
                                  "App Information",
                                  style: TextStyle(
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                      ]))),
        );
      },
    );
  }
}
