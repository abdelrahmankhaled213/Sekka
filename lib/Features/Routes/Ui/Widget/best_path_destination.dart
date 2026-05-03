import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';

class BestPathDestination extends StatelessWidget {

  final IconData icon;
  const BestPathDestination({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon,size: 40.sp,color: Colors.white,),
        
        SizedBox(height: 4.h,),
        Text(AppText.planYourRoute, style:AppStyle.regular16RobotoGrey.copyWith(
          color: Colors.white
        ),),
        
        SizedBox(height: 10.h,),

        Text(AppText.bestPathDestination, style:AppStyle.regular16RobotoGrey.copyWith(
          color: Colors.white
        ))
      ],

    );
  }
}