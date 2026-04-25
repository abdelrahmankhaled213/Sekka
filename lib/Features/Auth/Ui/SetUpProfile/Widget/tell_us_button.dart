import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import '../../../../../Core/Constants/app_style.dart';
import '../../../../../Core/Localization/app_localizations.dart';

class TellUsButton extends StatelessWidget {

  final double height;
  final double width;
  final void Function()onTap;
  const TellUsButton({super.key,required this.onTap,required this.height,required this.width});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0,4),
                  blurRadius: 4

              ),
            ],
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(colors: [
           AppColor.main.withOpacity(0.8),
              AppColor.secondary,
              AppColor.pink
            ]
                ,stops: [0,0.5,1],begin: Alignment.centerLeft
                ,end: Alignment.centerRight
            ),
          ),
          child:Center(child: Text(context.l10n.continuee
            ,style: AppStyle.regular18RobotoWhite.copyWith(
    fontSize: 16.sp,
        )
          )
    )


      ),
    );
  }

}
