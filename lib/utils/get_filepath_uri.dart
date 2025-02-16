import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const platform = MethodChannel('com.example.camcascade/filePath');

Future<String?> getFilePathFromContentUri(String contentUri) async {
  try {
    final String? filePath =
        await platform.invokeMethod('getFilePath', {'uri': contentUri});
    return filePath;
  } on PlatformException catch (e) {
    debugPrint("Error retrieving file path: $e");
    return null;
  }
}
