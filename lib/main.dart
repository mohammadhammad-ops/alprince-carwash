import 'package:alprince_carwash/core/theme/app_colors.dart';
import 'package:alprince_carwash/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
