import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Features/Auth/Logic/set_up_profile_cubit.dart';
import 'package:sekka/Features/Auth/Ui/Register/Widget/image_background.dart';
import 'package:sekka/Features/Auth/Ui/SetUpProfile/Widget/custom_linear_progress.dart';
import 'package:sekka/Features/Auth/Ui/SetUpProfile/Widget/setup_profile_switch.dart';

import '../../../../../Core/Constants/app_style.dart';
import '../../../../../Core/Localization/app_localizations.dart';
import '../../../../../Core/Helper/animation_helper.dart';
import '../../../../Splash/Widget/logo_container.dart';
import '../../../Logic/set_up_profile_state.dart';

class SetupProfileBody extends StatefulWidget {

  const SetupProfileBody({super.key});

  @override
  State<SetupProfileBody> createState() => _SetupProfileBodyState();
}

class _SetupProfileBodyState extends State<SetupProfileBody>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<Offset> _titleAnimation;
  late Animation<Offset> _subtitleAnimation;
  late Animation<Offset> _contentAnimation;

  bool _localizedSlideAnimationsReady = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _logoAnimation = AnimationHelper.buildAnimation(
      start: 0.0,
      end: 0.5,
      animationController: _controller,
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_localizedSlideAnimationsReady) return;
    _localizedSlideAnimationsReady = true;

    final languageCode = Localizations.localeOf(context).languageCode;

    _titleAnimation = AnimationHelper.buildLocalizedSlideAnimation(
      start: 0.2,
      end: 0.45,
      animationController: _controller,
      languageCode: languageCode,
    );
    _subtitleAnimation = AnimationHelper.buildLocalizedSlideAnimation(
      start: 0.25,
      end: 0.55,
      animationController: _controller,
      languageCode: languageCode,
    );
    _contentAnimation = AnimationHelper.buildLocalizedSlideAnimation(
      start: 0.3,
      end: 0.7,
      animationController: _controller,
      languageCode: languageCode,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: ImageBackground(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          child: Column(
            children: [

               Column(
                 children: [
                   _buildStepsOfLinearProgress(),
                   SizedBox(height: 10.h),
                   BlocBuilder<SetUpProfileCubit,SetupProfileState>(
                     builder: (context, state) =>
                   CustomLinearProgress(value:
                     context.read<SetUpProfileCubit>().state.progress),
                   ),
                 ],
               ),


              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      SizedBox(height: 24.h),

                      FadeTransition(
                        opacity: _logoAnimation,
                        child: LogoContainer(
                          height: 96.h,
                          width: 96.w,
                          radius: 25.r,
                        ),
                      ),

                      SizedBox(height: 13.h),

                      SlideTransition(
                        position: _titleAnimation,
                        child: Text(
                          context.l10n.completeYourProfile,
                          style: AppStyle.regular24RobotoBlack,
                        ),
                      ),

                      SizedBox(height: 6.h),

                      SlideTransition(
                        position: _subtitleAnimation,
                        child: Text(
                          context.l10n.helpUsPersonalizeYourSekkaExperience,
                          style: AppStyle.regular16RobotoGrey,
                          textAlign: TextAlign.center,
                        ),
                      ),

                      SizedBox(height: 20.h),

                      SlideTransition(
                        position: _contentAnimation,
                        child: SetupProfileSwitch(
                        ),
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepsOfLinearProgress() {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BlocBuilder<SetUpProfileCubit,SetupProfileState>(
          builder: (context, state) =>
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                      opacity: animation, child: child);
                },
                child: Text(
                  "Step ${context.read<SetUpProfileCubit>()
                      .state.step} of 2",
                  key: ValueKey(context.read<SetUpProfileCubit>().state.step),
                  style: AppStyle.regular16RobotoBlack.copyWith(fontSize: 14.sp),
                ),
                  
                  
              ),
              
              
        ),
        GestureDetector(
          onTap: () async{
            
            Navigator.pushReplacementNamed(context, AppRoute.bottomNavigation);
          },
          child: Text(
            
            AppText.skip,
            style: AppStyle.regular16RobotoBlack.copyWith(fontSize: 14.sp),
          ),
        ),
      ],
    );
  }







}