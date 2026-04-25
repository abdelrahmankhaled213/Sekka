import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Localization/app_localizations.dart';

class EmailInstruction extends StatelessWidget {

  const EmailInstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 8.sp,
          vertical: 10.sp
      ),
      decoration: BoxDecoration(
        color: AppColor.offWhite,
        borderRadius: BorderRadius.circular(20.r),

      ),
      child: Row(
        children: [
          Icon(Icons.email_outlined,size: 25.sp,color: AppColor.main,),
          SizedBox(
            width: 8.w,
          ),
        _buildColumn(context)
         ],
      ),
    );
  }
  Widget _buildColumn(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(context.l10n.receiveEmail,style: AppStyle.bold14RobotoBlue.copyWith(
          color: AppColor.black,
          fontSize: 12.sp
        ),),
        SizedBox(
          height: 6,
        ),

        Text(context.l10n.checkYourSpam,style: AppStyle.regular16RobotoGrey.copyWith(

          fontSize: 12.sp
        ),),

        SizedBox(
          height: 6,
        ),

        Text(context.l10n.makeSureYourEmailIsCorrect,style: AppStyle.regular16RobotoGrey.copyWith(

            fontSize: 12.sp
        ),),

        SizedBox(
          height: 6,
        ),

        Text(context.l10n.waitFewMinutes,style: AppStyle.regular16RobotoGrey.copyWith(

            fontSize: 12.sp
        ),),

      ],
    );

  }
}
