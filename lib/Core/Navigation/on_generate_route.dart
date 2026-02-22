import 'package:flutter/material.dart';
import 'package:sekka/Features/OnBoarding/Ui/Views/OnBoardingView.dart';

import '../../Features/Splash/View/splash_screen_view.dart';
import '../Constants/app_route.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoute.splash:
      return PageRouteBuilder(
        pageBuilder: (_, __, ___) => SplashScreenView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(14, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      );
    case AppRoute.onBoarding:
      return PageRouteBuilder(
        pageBuilder: (_, __, ___) => OnBoardingView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(14, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      );


    default:
      return MaterialPageRoute(
        builder: (_) => SplashScreenView()
      );
  }
}

