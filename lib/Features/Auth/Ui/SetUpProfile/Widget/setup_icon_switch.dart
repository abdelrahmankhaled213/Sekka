import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SetUpIconSwitch extends StatelessWidget {

  final Color firstColor;
  final Color secondColor;
  final IconData? icon;
  final String? image;
  const SetUpIconSwitch({super.key
    ,required this.secondColor
    ,required this.firstColor, this.icon,this.image});

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
            firstColor,
            secondColor,
          ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
      ),
      child: image!=null?Image.asset(
        image!,
      ):Icon(icon,size: 50.sp,color: Colors.white,),
    );
  }
}
