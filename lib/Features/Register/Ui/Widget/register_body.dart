import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Helper/animation_helper.dart';
import 'package:sekka/Features/Register/Ui/Widget/image_background.dart';
import 'package:sekka/Features/Register/Ui/Widget/signup_form.dart';
import 'package:sekka/Features/Splash/Widget/logo_container.dart';
import '../../../../Core/Constants/app_style.dart';
import '../../../../Core/Constants/app_text.dart';
import 'back_to_login.dart';

class RegisterBody extends StatefulWidget {
  
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();
_controller=AnimationController(vsync: this,duration: const Duration(seconds: 3));
_logoAnimation=AnimationHelper.buildAnimation(start: 0.0, end: 0.5
    , animationController: _controller
    , tween: Tween<double>(
      begin: 0,
      end: 1
    ),curve: Curves.easeInOut);

_controller.forward();

  }

  @override
  Widget build(BuildContext context) {
    return
        SingleChildScrollView(
         child: ImageBackground(
           child:Column(
             children: [
               SafeArea(child: BackToLogin()),

               SizedBox(
                 height: 24.h,
               ),

             FadeTransition(opacity: _logoAnimation
                 ,child: LogoContainer(height: 96.h, width: 96.w, radius: 25.r,)),
               SizedBox(
                 height: 13.h,
               ),
               Text(AppText.createAccount,style: AppStyle.regular24RobotoBlack,),
               SizedBox(
                 height: 6.h,
               ),
               Text(AppText.joinSekkaAndTravelSmart
                 ,style: AppStyle.regular16RobotoGrey,),

               SizedBox(
                 height: 32.h,
               ),
               SignupForm(),
             ],
           ),
         ),
                  );

  }
}
