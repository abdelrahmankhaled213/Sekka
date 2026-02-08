import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Features/OnBoarding/Ui/Views/OnBoardingView.dart';

class Sekka extends StatelessWidget {

const Sekka({super.key});

@override
Widget build(BuildContext context) {
  return ScreenUtilInit(
designSize: Size(394, 853),
    builder: (context, child) {
return MaterialApp(

  title: 'Sekka',

  home:OnBoardingView()

);
    },

  );
}
}
