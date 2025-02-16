package com.example.camcascade

import android.content.ContentResolver
import android.database.Cursor
import android.net.Uri
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine  // ✅ Add this import
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.camcascade/filePath"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) { // ✅ Fix here
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "getFilePath") {
                    val uriString = call.argument<String>("uri")
                    if (uriString != null) {
                        val filePath = getRealPathFromUri(uriString)
                        result.success(filePath)
                    } else {
                        result.error("INVALID_URI", "Invalid URI received", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun getRealPathFromUri(uriString: String): String? {
        val uri = Uri.parse(uriString)
        val projection = arrayOf(MediaStore.Images.Media.DATA)
        contentResolver.query(uri, projection, null, null, null)?.use { cursor ->
            val columnIndex = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA)
            if (cursor.moveToFirst()) {
                return cursor.getString(columnIndex)
            }
        }
        return null
    }
}
