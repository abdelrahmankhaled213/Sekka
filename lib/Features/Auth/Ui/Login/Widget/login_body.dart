import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Helper/animation_helper.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Features/Auth/Logic/auth_cubit.dart';
import 'package:sekka/Features/Auth/Logic/auth_state.dart';
import 'package:sekka/Features/Auth/Ui/Login/Widget/or_continue_with.dart';
import 'package:sekka/Features/Splash/Widget/logo_container.dart';
import 'package:sekka/core/theme/app_colors.dart';
import 'package:sekka/core/theme/app_radius.dart';
import 'package:sekka/core/theme/app_spacing.dart';
import 'package:sekka/core/theme/app_text_styles.dart';
import 'package:sekka/core/widgets/app_loading.dart';
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
  late Animation<Offset> _headlineSlide;
  bool _localizedAnimationsReady = false;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_localizedAnimationsReady) return;
    _localizedAnimationsReady = true;

    _headlineSlide = AnimationHelper.buildLocalizedSlideAnimation(
      start: 0.2,
      end: 0.7,
      animationController: _controller,
      languageCode: Localizations.localeOf(context).languageCode,
      distance: 0.45,
    );
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

  SizedBox(height: AppSpacing.xxl.h),

                   SafeArea(
                     child: FadeTransition(opacity: _logoAnimation
                      ,child: LogoContainer(height: 96.h, width: 96.w, radius: 25.r,)),
                   ),
  SizedBox(height: AppSpacing.xl.h),
  SlideTransition(
                position: _headlineSlide,
                child: Text(AppText.welcomeToSekka, style: AppTextStyles.headlineSmall(context)),
              ),
              SizedBox(height: AppSpacing.sm.h),
              Text(AppText.smartTransportation, style: AppTextStyles.bodyMedium(context)),
              SizedBox(height: AppSpacing.xxxl.h),

              LoginForm(),


  SizedBox(height: AppSpacing.md.h),
              ContinueWithDivider(),
              SizedBox(height: AppSpacing.xl.h),


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
  if (state is GoogleError) {
                        FlutterToastHelper.showToast(text: state.errorMsg, color: AppColors.error);
                      }
                  },
               
                  child: BlocBuilder<AuthCubit,AuthState>(
                    buildWhen: (previous, current) {
                      return current is GoogleLoaded||
                         current is GoogleLoading||
                      current is GoogleError;
                    },
                    builder: (context, state) {
  if (state is GoogleLoading) {
                        return const AppLoading(variant: AppLoadingVariant.circular);
                      }
                
  return Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.md.sp),
                          child: SizedBox(
                            width: 300.w,
                            height: 50.h,
                            child: ElevatedButton.icon(
                              onPressed: () => BlocProvider.of<AuthCubit>(context).loginWithGoogle(),
                              icon: Image.asset(AppImage.googleIcon, height: 22.h),
                              label: Text(AppText.signInWithGoogle, style: AppTextStyles.labelLarge(context)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Theme.of(context).colorScheme.onSurface,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.allLG,
                                  side: BorderSide(color: Theme.of(context).colorScheme.outline),
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
  
  if (state is GetProfileError) {
                    FlutterToastHelper.showToast(text: state.errorMsg, color: AppColors.error);
                  }
                  if (state is GetProfileSuccess) {
                    FlutterToastHelper.showToast(text: AppText.signInSuccessfully, color: AppColors.success);
                    final isGetStarted = state.isGettingStarted;
                    if (isGetStarted) {
                      Navigator.pushReplacementNamed(context, AppRoute.bottomNavigation);
                    } else {
                      Navigator.pushReplacementNamed(context, AppRoute.setUpProfile);
                    }
                  }
                
  }
}
