import 'package:flutter/material.dart';
import 'package:sekka/Features/Splash/Widget/splash_screen_body.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SplashScreenBody(),
    );
  }
}
