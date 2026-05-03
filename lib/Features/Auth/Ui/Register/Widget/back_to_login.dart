import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';

class BackToLogin extends StatelessWidget {

  final void Function() onTap;
  const BackToLogin({super.key,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onTap
        , icon: Icon(Icons.arrow_back_rounded 
              ,color: AppColor.grey,size: 20.sp,)),
        Text(AppText.backToLogin,style: AppStyle.regular16RobotoGrey,)
      ],
    );
  }
}
