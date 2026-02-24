import 'package:flutter/material.dart';
import 'package:sekka/Core/Navigation/custom_route_builder.dart';
import 'package:sekka/Features/OnBoarding/Ui/Views/OnBoardingView.dart';
import 'package:sekka/Features/Register/Ui/View/register_screen_view.dart';

import '../../Features/Splash/View/splash_screen_view.dart';
import '../Constants/app_route.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {

    case AppRoute.splash:
      return CustomPageRoute(page: SplashScreenView());
    case AppRoute.onBoarding:
      return CustomPageRoute(page: OnBoardingView());

    case AppRoute.register:
      return CustomPageRoute(page: RegisterScreenView());

    default:
      return MaterialPageRoute(
        builder: (_) => SplashScreenView()
      );
  }

}
