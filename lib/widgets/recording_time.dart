// This widget will update only when the recording time changes
import 'package:camcascade/providers/camera_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordingTimeDisplay extends StatelessWidget {
  final CameraProvider cameraProvider;

  RecordingTimeDisplay({required this.cameraProvider});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: cameraProvider.recordingTimeNotifier,
      builder: (context, value, child) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Container(
              height: 60,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  value, // Only this text updates!
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.sp,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}