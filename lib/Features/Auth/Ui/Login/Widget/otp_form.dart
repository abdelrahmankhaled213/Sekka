import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import '../../../../../Core/Constants/app_color.dart';
import '../../../../../Core/Helper/toast_helper.dart';
import '../../../../../Core/Widget/custom_button_core.dart';
import '../../../Logic/auth_cubit.dart';
import '../../../Logic/auth_state.dart';
import 'otp_instruction.dart';


class OtpForm extends StatefulWidget {

  const OtpForm({super.key,});

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> with SingleTickerProviderStateMixin{

  bool isCompletedPin=false;
  bool isCompleted=false;
  late final PinInputController otpController;
  late AnimationController shakeController;
  late Animation<double> shakeAnimation;
  String phoneNumber="";

  @override
  void initState() {

     super.initState();
     final state=context.read<AuthCubit>().state;
 if(state is AuthOtpState) {
   phoneNumber =state.phone;
 }
     otpController=PinInputController();
  shakeController=AnimationController(vsync: this,
    duration: const Duration(seconds: 1),
  );
  shakeAnimation=Tween<double>(
    begin: 0,
    end: 12
  ).chain(CurveTween(curve: Curves.elasticInOut))
      .animate(shakeController);
  }

  @override
  void dispose(){
    super.dispose();
    shakeController.stop();
    shakeController.dispose();
    otpController.dispose();

  }

  @override
  Widget build(BuildContext context) {
 return Padding(

       padding: EdgeInsets.symmetric(horizontal: 16.w),

       child: Container(

       padding: EdgeInsets.all(33.sp),

    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24.r)
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [

      Align(child: Text(AppText.enterVerificationCode,style: AppStyle.regular16RobotoBlack,)),

      SizedBox(
        height: 12.h,
      ),

      AnimatedBuilder(
        animation:shakeAnimation ,
        builder: (context, child) =>
       Transform.translate(
        offset: Offset(shakeAnimation.value,0),
         child: child),
        child: MaterialPinField(
          pinController:otpController ,
          length: 6,
autoDismissKeyboard: true,
          onChanged: (value) {

           if(value.length<6){
              setState(() {
                isCompleted=false;
              });
            }
            else{
              setState(() {
                isCompleted=true;

              });
                }
          },
          theme: MaterialPinTheme(
            cursorColor: AppColor.main,

            borderColor: AppColor.grey,
errorBorderColor: Colors.red,
            elevation: 12.sp,
            errorFillColor: Colors.red,

            errorColor: Colors.red,
            animationCurve: Curves.easeInOut,
            shape: MaterialPinShape.outlined,
            cellSize: Size(40.w, 50.h),
            borderRadius: BorderRadius.circular(12.r),
            animateCursor: true,
          ),
        ),

      ),

     SizedBox(
     height: 12.h,
     ),

     OtpInstruction(),

     SizedBox(
     height: 17.h,
     ),

     BlocConsumer<AuthCubit,AuthState>(
       listener: (context, state) {
         if (state is OtpFailure) {
           shakeController.forward(from: 0);
           FlutterToastHelper.showToast(
               text: state.errorMsg,
               color: AppColor.error
           );
         }

         if (state is OtpSuccess) {
           showGeneralDialog(
             context: context,
             barrierDismissible: true,
             barrierLabel: AppText.verificationSuccess,
             barrierColor: Colors.black54,
             transitionDuration: const Duration(milliseconds: 300),

             pageBuilder: (context, animation, secondaryAnimation) {
               return _showDialogWidget(context);
             },

             transitionBuilder: (context, animation, secondaryAnimation, child) {
               return Transform.scale(
                 scale: animation.value,
                 child: Opacity(
                   opacity: animation.value,
                   child: child,
                 ),
               );
             },

           );

         }

       },
       listenWhen: (previous, current) {
         return current is OtpSuccess
             ||current is OtpFailure;
       },

       buildWhen: (previous, current) {
         return current is OtpSuccess
             || current is OtpFailure
             || current is OtpLoading;

       },
       builder: (context, state) =>
        state is OtpLoading
        ?Align(
          child: CircularProgressIndicator(
            color: AppColor.main,
          ),
        ):Align(
          child: AnimatedOpacity(
            opacity: isCompleted?1:0.4,
            duration: Duration(
              seconds: 1
            ),
            child: CustomButtonCore(
                   text:
               AppText.verifyCode,
              height: 56.h,
              width: 274.w,
              onPressed: isCompleted?_otpPressed:null,
              firstColor: AppColor.main,
              secondColor: AppColor.secondary,
              thirdColor: AppColor.pink,
              child: Center(child: Text(AppText.verifyCode,style: AppStyle.regular18RobotoWhite,)),
            ),
          ),
        ),
     )

   ] )
   )
    );
  }

  void _otpPressed()async{
await  BlocProvider.of<AuthCubit>(context)
    .submitOtp(otpController.text,phoneNumber);
  }
  Center _showDialogWidget(BuildContext context) {
    return Center(
               child: Container(
                 margin: EdgeInsets.symmetric(horizontal: 30.w),
                 padding: EdgeInsets.all(24.sp),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(24.r),
                 ),
                 child: Material(
                   color: Colors.transparent,
                   child: Column(
                     mainAxisSize: MainAxisSize.min,
                     children: [

                       Container(
                         height: 70.h,
                         width: 70.w,
                         decoration: BoxDecoration(
                           color: Colors.green.withOpacity(.1),
                           shape: BoxShape.circle,
                         ),
                         child: const Icon(
                           Icons.check,
                           color: Colors.green,
                           size: 40,
                         ),
                       ),

                       SizedBox(height: 16.h),

                       Text(
                         AppText.verificationSuccess,
                         style: AppStyle.regular16RobotoBlack,
                       ),

                       SizedBox(height: 8.h),

                       Text(
                         AppText.phoneVerifiedSuccessfully,
                         textAlign: TextAlign.center,
                         style: AppStyle.regular16RobotoGrey.copyWith(
                           fontSize: 14.sp
                         ),
                       ),

                       SizedBox(height: 20.h),

                       SizedBox(
                         width: double.infinity,
                         child: ElevatedButton(
                           style: ElevatedButton.styleFrom(
                             backgroundColor: AppColor.main,
                             padding: EdgeInsets.symmetric(vertical: 14.h),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(14.r),
                             ),
                           ),
                           onPressed: () {

                             Navigator.pop(context);


                              },

                           child:  GestureDetector(onTap: () =>
                              Navigator.pushReplacementNamed(context, AppRoute.setUpProfile)
                               ,child: Text(AppText.continuee,style: AppStyle.regular18RobotoWhite,)),
                         ),
                       )
                     ],
                   ),
                 ),
               ),
             );
  }
}
