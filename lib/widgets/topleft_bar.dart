import 'package:camcascade/providers/theme_provider.dart';
import 'package:camcascade/screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:camcascade/providers/camera_provider.dart';

Widget topLeftBar(BuildContext context, VoidCallback toggleScanner, bool isQrScannerActive) {
  var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  var cameraProvider = Provider.of<CameraProvider>(context);

  return SafeArea(
    child: Align(
      alignment: Alignment.topRight,
      child: Padding(
          padding: EdgeInsets.all(10.0.w),
          child: Column(
            children: [
              if(!isQrScannerActive)
              // Setting Icon
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingScreen()));
                },
                child: Container(
                  height: 50.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(60.r)),
                  child: Icon(
                    Icons.settings,
                    color: Theme.of(context).hintColor,
                    size: 30,
                  ),
                ),
              ),

              if(!isQrScannerActive)
              // Focus Icon
              GestureDetector(
                onTap: cameraProvider.toggleFocusMode,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(60.r)),
                    child: cameraProvider.isLockedFocus
                        ? Icon(
                            Icons.lock_person_outlined,
                            color: Theme.of(context).hintColor,
                            size: 30,
                          )
                        : Icon(
                            Icons.center_focus_strong,
                            color: Theme.of(context).hintColor,
                            size: 30,
                          ),
                  ),
                ),
              ),

              // Qr Code Icon
              GestureDetector(
                onTap: toggleScanner,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Container(
                    height: 50.h,
                    width: 50.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: isQrScannerActive ? Theme.of(context).hintColor : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(60.r)),
                    child: isQrScannerActive
                        ? Icon(
                            Icons.qr_code_2_rounded,
                            color: isQrScannerActive ? Theme.of(context).cardColor : Theme.of(context).hintColor,
                            size: 30,
                          )
                        : Icon(
                            Icons.qr_code_2_rounded,
                            color: isQrScannerActive ? Theme.of(context).cardColor : Theme.of(context).hintColor,
                            size: 30,
                          ),
                  ),
                ),
              ),

              // Theme Icon
              GestureDetector(
                onTap: themeProvider.toggleTheme,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                        color: themeProvider.themeMode == ThemeMode.dark
                            ? Theme.of(context).hintColor
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(60.r)),
                    child: themeProvider.themeMode == ThemeMode.dark
                        ? Icon(
                            Icons.dark_mode,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Theme.of(context).cardColor
                                : Theme.of(context).hintColor,
                            size: 30,
                          )
                        : Icon(
                            Icons.light_mode,
                            color: themeProvider.themeMode == ThemeMode.dark
                                ? Theme.of(context).cardColor
                                : Theme.of(context).hintColor,
                            size: 30,
                          ),
                  ),
                ),
              ),
            ],
          )),
    ),
  );
}
