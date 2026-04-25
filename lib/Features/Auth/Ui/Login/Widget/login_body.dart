import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Helper/animation_helper.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Features/Auth/Logic/auth_cubit.dart';
import 'package:sekka/Features/Auth/Logic/auth_state.dart';
import 'package:sekka/Features/Auth/Ui/Login/Widget/or_continue_with.dart';
import 'package:sekka/Features/Splash/Widget/logo_container.dart';
import '../../../../../../Core/Constants/app_style.dart';
import '../../../../../../Core/Localization/app_localizations.dart';

import '../../../../../Core/Constants/app_color.dart';
import '../../../../../Core/Constants/app_image.dart';
import '../../Register/Widget/image_background.dart';
import 'login_form.dart';

class LoginBody extends StatefulWidget {

  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> with SingleTickerProviderStateMixin {

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
    return
      SingleChildScrollView(
        child: ImageBackground(
          child:Column(
            children: [

              SizedBox(
                height: 24.h,
              ),

                   SafeArea(
                     child: FadeTransition(opacity: _logoAnimation
                      ,child: LogoContainer(height: 96.h, width: 96.w, radius: 25.r,)),
                   ),
              SizedBox(
                height: 13.h,
              ),
              Text(context.l10n.welcomeToSekka,style: AppStyle.regular24RobotoBlack,),
              SizedBox(
                height: 6.h,
              ),
              Text(context.l10n.smartTransportation
                ,style: AppStyle.regular16RobotoGrey,),

              SizedBox(
                height: 32.h,
              ),

              LoginForm(),


              SizedBox(
                height: 10.h,
              ),

              ContinueWithDivider(),
              SizedBox(
                height: 18.h,
              ),


              BlocListener<AuthCubit,AuthState>(

                listener: _listenGetStarted,
                
                listenWhen: (previous, current) {

                  return current is GetProfileSuccess||
                      current is GetProfileError;
                },
                child: BlocListener<AuthCubit,AuthState>(
                  
                  listener: (context, state) async{
                    if(state is GoogleLoaded){
                
                      await context.read<AuthCubit>().getProfile();
                      
                    }
                    if(state is GoogleError){
                      FlutterToastHelper.showToast(text: state.errorMsg);
                    }
                  },
               
                  child: BlocBuilder<AuthCubit,AuthState>(
                    buildWhen: (previous, current) {
                      return current is GoogleLoaded||
                         current is GoogleLoading||
                      current is GoogleError;
                    },
                    builder: (context, state) {
                      if(state is GoogleLoading){
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColor.main,
                          ),
                        );
                      }
                
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.sp),
                          child: SizedBox(
                            width: 300.w,
                            height: 50.h,
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  BlocProvider.of<AuthCubit>(context).loginWithGoogle(),
                              icon: Image.asset(
                                AppImage.googleIcon,
                                height: 22.h,
                              ),
                              label: Text(
                                "Sign in with Google",
                                style: AppStyle.regular18RobotoWhite.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: 16.sp,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Theme.of(context).colorScheme.onSurface,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.h,
                                  horizontal: 16.w,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                  side: BorderSide(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                
                
                
                    } ),
                ),
              )

            ],
          ),
        ),
      );

  }

  void _listenGetStarted(BuildContext context, AuthState state) {
  
                  if(state is GetProfileError){
                    FlutterToastHelper.showToast(text: state.errorMsg);
                  }
                  if(state is GetProfileSuccess){
                    
                    FlutterToastHelper.showToast(text: context.l10n.signInSuccessfully);
                   
                    final isGetStarted=state.isGettingStarted;
                    
                    if(isGetStarted){
                      Navigator.pushReplacementNamed(context, AppRoute.bottomNavigation);
                    }else{
                    Navigator.pushReplacementNamed(context, AppRoute.setUpProfile);
                    }
                  }
                
  }
}
