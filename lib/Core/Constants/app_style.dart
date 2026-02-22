
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_color.dart';

abstract class AppStyle {

  static final TextStyle bold48RobotoWhite = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 48.sp,
      fontFamily: 'Roboto',
      color: Colors.white
  );


  static final TextStyle regular18RobotoWhite = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 18.sp,
      fontFamily: 'Roboto',
      color: Colors.white
  );

  static final TextStyle regular16RobotoGrey = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16.sp,
      fontFamily: 'Roboto',
      color: AppColor.grey
  );


}