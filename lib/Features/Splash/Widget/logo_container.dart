import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../Core/Constants/app_image.dart';
class LogoContainer extends StatelessWidget {

final double height;
final double width;

  const LogoContainer({super.key,required this.height,required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(

      alignment: Alignment.center,
height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 20),
              blurRadius: 25.r,


            ),
            
          ],
      ),
child: Image.asset(AppImage.logo,fit: BoxFit.fitHeight,)
    );
  }
}
