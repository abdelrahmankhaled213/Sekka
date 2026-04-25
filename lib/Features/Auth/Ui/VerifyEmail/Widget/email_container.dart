import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';

class EmailContainer extends StatelessWidget {
  const EmailContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:80.h,
      width: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadiusGeometry.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius:7,
            offset: Offset(0, 4)
          )
        ],
        gradient: LinearGradient(colors: [
          AppColor.main,
          AppColor.secondary,
        ],
        begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      ),
      child: Icon(Icons.email_outlined,size: 50.sp,color: Colors.white,),
    );
  }
}
