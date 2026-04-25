import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Features/Auth/Ui/ForgotPassword/Widget/forgot_password_form.dart';

import '../../../../../Core/Constants/app_style.dart';
import '../../../../../Core/Localization/app_localizations.dart';
import '../../../../../Core/Helper/animation_helper.dart';
import '../../../../Splash/Widget/logo_container.dart';
import '../../../Logic/auth_cubit.dart';
import '../../Register/Widget/back_to_login.dart';
import '../../Register/Widget/image_background.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> with SingleTickerProviderStateMixin{

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
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return
      SingleChildScrollView(
          child: ImageBackground(
              child: Column(
                  children: [

                    SafeArea(
                        child: BackToLogin(
                            onTap: () =>
                                authCubit.navigateToSignIn()
                        )),

                    SizedBox(
                      height: 24.h,
                    ),

                    FadeTransition(opacity: _logoAnimation
                        ,
                        child: LogoContainer(
                          height: 96.h, width: 96.w, radius: 25.r,)),
                    SizedBox(
                      height: 13.h,
                    ),
                    Text(context.l10n.forgotPassword,
                      style: AppStyle.regular24RobotoBlack,),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(context.l10n.passwordHelpYou
                      , style: AppStyle.regular16RobotoGrey,),

                    SizedBox(
                      height: 32.h,
                    ),

                    ForgotPasswordForm(),

                  ])

          ));
  }
}
