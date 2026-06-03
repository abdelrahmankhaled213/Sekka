import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Helper/app_regex_helper.dart';
import 'package:sekka/Core/Widget/custom_text_field.dart';
import 'package:sekka/Features/Auth/Logic/set_up_profile_cubit.dart';
import 'package:sekka/Features/Auth/Ui/SetUpProfile/Widget/instruction_tell_about_yourself.dart';
import 'package:sekka/Features/Auth/Ui/SetUpProfile/Widget/photo_widget.dart';
import 'package:sekka/Features/Auth/Ui/SetUpProfile/Widget/setup_icon_switch.dart';
import 'package:sekka/Features/Auth/Ui/SetUpProfile/Widget/tell_us_button.dart';
import '../../../../../Core/Constants/app_style.dart';
import '../../../../../Core/Localization/app_localizations.dart';

class TellUsAboutYourSelf extends StatelessWidget {

  const TellUsAboutYourSelf({super.key});

  @override
  Widget build(BuildContext context) {

    return
      Container(

          padding: EdgeInsets.all(20.sp),

          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r)
          ),
          child:
      Form(

      key: context.read<SetUpProfileCubit>().globalKey,

      child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Center(
            child: SetUpIconSwitch(secondColor: AppColor.main
                , firstColor: AppColor.secondary, icon: Icons.person),
          ),

       SizedBox(
       height: 6.h,
       ),

          Center(
            child: Text(context.l10n.tellUsAboutYourSelf
              ,style: AppStyle.regular24RobotoBlack.copyWith(
                fontSize: 16.sp
              ),),
          ),
          SizedBox(
            height: 6.h,
          ),

          Center(
            child: Text(context.l10n.letsStartWithTheBasics
              ,style: AppStyle.regular16RobotoGrey.copyWith(
                fontSize:14.sp
              )),
          ),

      SizedBox(
      height: 14.h,
      ),

           Text(context.l10n.profilePicture
              ,style: AppStyle.regular24RobotoBlack.copyWith(
                  fontSize: 14.sp
              ),),

          SizedBox(
            height: 8.h,
          ),


      PhotoWidget(
      ),

          SizedBox(
            height: 12.sp,
          ),

            Text("Phone Number"
              ,style: AppStyle.regular24RobotoBlack.copyWith(
                  fontSize: 14.sp
              ),),


          SizedBox(
            height: 6.sp,
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: MyTextFormField(
            validator: (value) {
              if(value==null||value.isEmpty){
                return "Phone number is empty";
              }
              if(!AppRegex.isPhoneNumberValid(value)){
                return "Phone number is not valid";
              }
              
              return null;
            }
            ,prefixIcon: Icon(Icons.phone,color: AppColor.grey,size: 20.sp,),
            controller: context.read<SetUpProfileCubit>().phoneController
                , hint: "Phone number",),
          ),

          SizedBox(
            height: 12.sp,
          ),

      InstructionTellAboutYourself(),

          SizedBox(
            height: 16.sp,
          ),

          TellUsButton(
            onTap: () => _onPressedNext(context),
            height: 56.h,
             width: 274.w,
          )

        ],

      ),
    )
      );
  }

  Future<void> _onPressedNext(BuildContext context) async {
    final cubit = context.read<SetUpProfileCubit>();

    if (cubit.globalKey.currentState!.validate()) {

      cubit.goNextPage();
    }

  }

}
