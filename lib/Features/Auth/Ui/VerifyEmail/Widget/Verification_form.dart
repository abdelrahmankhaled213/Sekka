import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Core/Widget/custom_button_core.dart';
import 'package:sekka/Features/Auth/Logic/auth_cubit.dart';
import 'package:sekka/Features/Auth/Logic/auth_state.dart';
import 'package:sekka/Features/Auth/Ui/VerifyEmail/Widget/email_container.dart';
import 'package:sekka/Features/Auth/Ui/VerifyEmail/Widget/verify_email_instructions.dart';
import '../../../../../Core/Localization/app_localizations.dart';

class VerificationForm extends StatefulWidget {

  const VerificationForm({super.key});

  @override
  State<VerificationForm> createState() => _VerificationFormState();
}

class _VerificationFormState extends State<VerificationForm> {

  Timer? timer;
  int secondsRemaining=60;
  int maxAttempts=1;
  bool isTimeStarted=true;

  void startTimer(){
    secondsRemaining=60;
    isTimeStarted=true;
    timer=Timer.periodic(const Duration(
      seconds: 1
    ), (timer){
      if(secondsRemaining==0){

        setState(() {
          isTimeStarted=false;
        });
        timer.cancel();
      } else{

        setState(() {
          secondsRemaining--;

        });

      }
    });
  }

  @override
  void initState() {

    super.initState();

    startTimer();

  }
  @override
  Widget build(BuildContext context) {
    return Padding(

        padding: EdgeInsets.symmetric(horizontal: 16.w),

        child: Container(

            padding: EdgeInsets.all(25.sp),

            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r)
            ),
            child: Column(
                children: [

                  Align(

                      child:EmailContainer()

                  ),

                  SizedBox(
                    height: 12.h,
                  ),

                  Text(context.l10n.checkYourInBox
                    , style:AppStyle.regular16RobotoBlack ,),

                  SizedBox(
                    height: 6.h,
                  ),

                  Text(context.l10n.clickYourVerificationLink,
                    textAlign: TextAlign.center
                    , style:AppStyle.regular16RobotoGrey.copyWith(
                      fontSize: 14.sp
                    ) ,),

                  SizedBox(
                    height: 22.h,
                  ),

                  EmailInstruction(),

                  SizedBox(
                    height: 16.h,
                  ),


         BlocListener<AuthCubit,AuthState>(
           listener: (context, state) {

             if(state is ResendEmailSuccess){
FlutterToastHelper.showToast(text: "Email sent",color: AppColor.error);
startTimer();

             }

             if(state is ResendEmailFailiure){
               FlutterToastHelper.showToast(text: state.errorMsg,color: AppColor.error);
             }
           },


           child: Padding(
               padding: EdgeInsets.only(bottom: 12.sp),
               child: SizedBox(
               width: 300.w,
               height: 50.h,
               child: isTimeStarted?
               _buildColumn(context):ElevatedButton.icon(
               onPressed: () async {

                 if(maxAttempts>=3){
                   FlutterToastHelper.showToast(text: context.l10n.maxAttemptsForVerf,color: AppColor.error);
                   return;
                 }

                 setState(() {
                   maxAttempts++;
                 });

          context.read<AuthCubit>().resendEmail();

                  },
               icon: Icon(Icons.replay,size: 20.sp,),
               label: Text(
               context.l10n.resendEmailVerification,
               style: AppStyle.regular18RobotoWhite.copyWith(
               color: Theme.of(context).colorScheme.onSurface,

               ),
               ),
               style: ElevatedButton.styleFrom(
               backgroundColor: AppColor.offWhite,
               foregroundColor: Theme.of(context).colorScheme.onSurface,
               padding: EdgeInsets.symmetric(
               vertical: 12.h,
               horizontal: 16.w,
               ),
               shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(16.r),

               ),
               ),
               )
               ),
               ),
         ),


                  BlocConsumer<AuthCubit,AuthState>(

                    listener: (context, state) {
                    if(state is VerifyUserSuccess){
                      if(state.isVerified) {
                        FlutterToastHelper.showToast(
                            text: "Email is verified",
                            color: AppColor.success
                            );
                      Navigator.pushReplacementNamed(context,AppRoute.setUpProfile);
                      }
                      else{

                        FlutterToastHelper.showToast(
                            text: "Email is not verified",
                            color: AppColor.error
                            
                            );
                      }
                    }

                    if(state is VerifyUserFailed){
                      FlutterToastHelper.showToast(
                        color:AppColor.error,
                          text: state.errorMsg);  
                    }

                    },

                    listenWhen: (previous, current) {

                      return current is VerifyUserSuccess
                          || current is VerifyUserFailed;

                    },
                    builder: (context, state) {

                   return  state is VerifyUserLoading ?
                   Center(
                       child: CircularProgressIndicator(
                         color: AppColor.main,
                       ),
                     ): CustomButtonCore(
                           onPressed: ()=>
                           context.read<AuthCubit>().isVerifiedUser()
                           , width: 300.w, height:50.h
                       , firstColor: AppColor.main
                           , secondColor: AppColor.secondary
                       ,thirdColor: AppColor.pink, text:"",
                           child:
                           Center(child: Text(context.l10n.iHaveVerifiedMyEmail
                             ,style: AppStyle.regular18RobotoWhite,)
                           )
                   );

                    },

                    buildWhen: (previous, current) {
                      return current is VerifyUserLoading
                          || current is VerifyUserSuccess ||
                      current is VerifyUserFailed;

                    },
 ),
    ]),
                  )


    );
  }
 Widget _buildColumn(BuildContext context){
    return Column(
      children: [
        Text(context.l10n.receiveEmail,style: AppStyle.regular16RobotoGrey.copyWith(
          fontSize: 12.sp
        ),),
        SizedBox(
          height: 2.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.replay,size:12.sp ,color: AppColor.main,),
            SizedBox(
              width: 8.w,
            ),
            Text("${context.l10n.resendEmailIn}${secondsRemaining}s",
              style: AppStyle.regular16RobotoGrey.copyWith(
              color: AppColor.main,
                fontSize: 12.sp
            ),)
          ],
        )
      ],
    );
  }
}
