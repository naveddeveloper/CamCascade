import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:camcascade/providers/camera_provider.dart';
import 'package:camcascade/providers/theme_provider.dart';
import 'package:camcascade/screens/home_screen.dart';
import 'package:camcascade/styles/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CameraProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const CameraApp(),
    ),
  );
}

class CameraApp extends StatelessWidget {
  const CameraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedSplashScreen(
      duration: 1500,
      splash: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/img/cascadesplashicon.png", width: 200.w),
            SizedBox(height: 20.h),
            Text(
              "CamCascade",
              style: TextStyle(
                color: Theme.of(context).cardColor,
                fontSize: 30.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      nextScreen: const HomeScreen(),
      centered: true,
      curve: Curves.fastOutSlowIn,
      splashIconSize: 400,
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
