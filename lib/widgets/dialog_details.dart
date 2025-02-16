import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> dialogBuilder(BuildContext context, File myimage) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text('Details Info',
            style: TextStyle(
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).cardColor)),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "File Name: ",
                    style: TextStyle(
                        fontSize: 18.sp, color: Theme.of(context).cardColor),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    myimage.toString().split("/").last,
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "File Info: ",
                    style: TextStyle(
                        fontSize: 18.sp, color: Theme.of(context).cardColor),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    myimage.path.toString(),
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Local Path: ",
                      style: TextStyle(
                          fontSize: 18.sp, color: Theme.of(context).cardColor)),
                  Text(
                    myimage.absolute.toString(),
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp),
                  )
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).hintColor,
                    foregroundColor: Theme.of(context).cardColor),
                child: Text(
                  'Details Share',
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                ),
                onPressed: () async {
                  String myFilename = myimage.toString().split("/").last;
                  String myDetails =
                      "Filename: $myFilename - Path: ${myimage.path} - Absoulute Path: ${myimage.absolute.path}";
                  await Share.share(myDetails);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).hintColor,
                      foregroundColor: Theme.of(context).cardColor),
                  child: Text('Cancel',
                      style:
                          TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          )
        ],
      );
    },
  );
}
