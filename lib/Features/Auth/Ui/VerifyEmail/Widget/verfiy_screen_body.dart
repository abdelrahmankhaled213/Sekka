import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Features/Auth/Logic/auth_state.dart';
import 'package:sekka/Features/Auth/Ui/VerifyEmail/Widget/back_to_signup.dart';

import '../../../../../Core/Constants/app_style.dart';
import '../../../../../Core/Localization/app_localizations.dart';
import '../../../../../Core/Helper/animation_helper.dart';
import '../../../../Splash/Widget/logo_container.dart';
import '../../../Logic/auth_cubit.dart';
import '../../Register/Widget/image_background.dart';
import 'Verification_form.dart';

class VerifyEmailBody extends StatefulWidget {


  const VerifyEmailBody({super.key,});

  @override
  State<VerifyEmailBody> createState() => _VerifyEmailBodyState();
}

class _VerifyEmailBodyState extends State<VerifyEmailBody> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  String email='';
  bool isBackToLogin=false;

  @override
  void initState() {
    super.initState();

    final state=context.read<AuthCubit>().state;
    if(state is AuthVerificationState){
      email=state.email;
       isBackToLogin=state.backToLogin;
    }
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
print(authCubit.state);
    return
      SingleChildScrollView(
          child: ImageBackground(
              child: Column(
                  children: [

                    SafeArea(
                        child: BackWidget(

                          backTo:isBackToLogin?AppLocalizations.of(context).backToLogin
                              :context.l10n.backToSignUp,

                            onTap: () =>
                                isBackToLogin?authCubit.navigateToSignIn():authCubit.navigateToSignUp()
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
                    Text(context.l10n.verifyEmailTitle,
                      style: AppStyle.regular24RobotoBlack,),
                    SizedBox(
                      height: 6.h,
                    ),

                    Text(context.l10n.sentVerificationEmail
                      , style: AppStyle.regular16RobotoGrey,),

                    SizedBox(
                      height: 3.h,
                    ),

                    Text(
                      email,style: AppStyle.regular16RobotoGrey,),

                    SizedBox(
                      height: 32.h,
                    ),

                    VerificationForm(),

                  ])

          ));
  }
}


