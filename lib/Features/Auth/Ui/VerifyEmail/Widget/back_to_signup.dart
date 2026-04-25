import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
class BackWidget extends StatelessWidget {

  final void Function() onTap;
  final String backTo;
  const BackWidget({super.key,required this.onTap,required this.backTo});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onTap
            , icon: Icon(Icons.arrow_back_rounded
              ,color: AppColor.grey,size: 20.sp,)),
        Text(backTo,style: AppStyle.regular16RobotoGrey,)
      ],
    );
  }
}
