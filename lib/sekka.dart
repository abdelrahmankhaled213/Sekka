import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Navigation/on_generate_route.dart';

class Sekka extends StatelessWidget {

const Sekka({super.key});

@override
Widget build(BuildContext context) {
  return ScreenUtilInit(
designSize: Size(394, 853),
     splitScreenMode: true,
    builder: (context, child) {
return MaterialApp(
debugShowCheckedModeBanner: false,
  title: 'Sekka',

onGenerateRoute: onGenerateRoute,
);
    },


  );
}
}
