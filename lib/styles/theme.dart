import 'package:camcascade/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColorsLight.barColor,
    iconTheme: IconThemeData(color: AppColorsLight.iconBackgroundColor),
    titleTextStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: AppColorsLight.iconBackgroundColor,
        fontFamily: 'Arial'),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColorsLight.barColor,
    elevation: 2.0,
    surfaceTintColor: AppColorsLight.iconBackgroundColor,
  ),
  scaffoldBackgroundColor: AppColorsLight.backgroundColor,
  progressIndicatorTheme:
      ProgressIndicatorThemeData(color: AppColorsLight.iconBackgroundColor),
  primaryColor: AppColorsLight.barColor,
  cardColor: AppColorsLight.iconBackgroundColor,
  hintColor: AppColorsLight.iconForegroundColor,
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    headlineMedium: TextStyle(
      fontSize: 28.sp,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    headlineSmall: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    bodyLarge: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    bodySmall: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
    labelLarge: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: AppColorsLight.iconBackgroundColor,
    ),
    labelMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      color: AppColorsLight.iconBackgroundColor,
    ),
    labelSmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
      color: AppColorsLight.iconBackgroundColor,
    ),
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColorsDark.barColor,
    iconTheme: IconThemeData(color: AppColorsDark.iconBackgroundColor),
    titleTextStyle: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: AppColorsDark.iconBackgroundColor,
        fontFamily: 'Arial'),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColorsDark.barColor,
    elevation: 2.0,
    surfaceTintColor: AppColorsDark.iconBackgroundColor,
  ),
  primaryColor: AppColorsDark.barColor,
  cardColor: AppColorsDark.iconBackgroundColor,
  hintColor: AppColorsDark.iconForegroundColor,
  scaffoldBackgroundColor: AppColorsDark.backgroundColor,
  progressIndicatorTheme:
      ProgressIndicatorThemeData(color: AppColorsDark.iconBackgroundColor),
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 28.sp,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    labelLarge: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: AppColorsDark.iconBackgroundColor,
    ),
    labelMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
      color: AppColorsDark.iconBackgroundColor,
    ),
    labelSmall: TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
      color: AppColorsDark.iconBackgroundColor,
    ),
  ),
);
