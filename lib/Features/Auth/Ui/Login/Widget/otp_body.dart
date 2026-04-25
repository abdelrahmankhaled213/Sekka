import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Features/Auth/Logic/auth_cubit.dart';
import '../../../../../Core/Constants/app_style.dart';
import '../../../../../Core/Localization/app_localizations.dart';
import '../../../../../Core/Helper/animation_helper.dart';
import '../../../../Splash/Widget/logo_container.dart';
import '../../Register/Widget/back_to_login.dart';
import '../../Register/Widget/image_background.dart';
import 'otp_form.dart';

class OtpBody extends StatefulWidget {

  final String phoneNumber;

  const OtpBody({super.key,required this.phoneNumber
    });

  @override
  State<OtpBody> createState() => _OtpBodyState();
}

class _OtpBodyState extends State<OtpBody> with SingleTickerProviderStateMixin{

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
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
      return SingleChildScrollView(
          child: ImageBackground(
            child:SafeArea(
              child: Column(
                children: [

              BackToLogin(
                onTap: () => context.read<AuthCubit>().navigateToSignIn(),
              ),

                  SizedBox(
                    height: 24.h,
                  ),

                  SafeArea(
                    child:
                    FadeTransition(opacity: _logoAnimation
                        ,child: LogoContainer(height: 96.h, width: 96.w , radius: 25.r,)),
                  ),
                  SizedBox(
                    height: 13.h,
                  ),
                  Text(context.l10n.verifyPhoneNumber
                    ,style: AppStyle.regular24RobotoBlack,),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(context.l10n.send6DigitCode
                    ,style: AppStyle.regular16RobotoGrey,),

                  SizedBox(
                    height: 3.h,
                  ),

                  Text(widget.phoneNumber
                    ,style: AppStyle.regular16RobotoGrey,),

                  SizedBox(
                    height: 32.h,
                  ),

                  OtpForm(

                  ),

                ],
              ),
            ),
          )
      );
  }
}
