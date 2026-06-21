import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Constants/cached_keys.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Core/Database/cache_helper.dart';
import 'package:sekka/core/theme/app_colors.dart';
import 'package:sekka/core/theme/app_radius.dart';
import 'package:sekka/core/theme/app_spacing.dart';
import 'package:sekka/core/theme/app_text_styles.dart';
import 'package:sekka/Features/Splash/Widget/logo_container.dart';

class SplashScreenBody extends StatefulWidget {
  const SplashScreenBody({super.key});

  @override
  State<SplashScreenBody> createState() => _SplashScreenBodyState();
}

class _SplashScreenBodyState extends State<SplashScreenBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _beginAlignment;
  late Animation<Alignment> _endAlignment;
  late Animation<double> _fadeInAnimation;
  late Animation<Color?> _colorIndicatorAnimate;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);

    _beginAlignment = Tween<Alignment>(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    ).animate(_controller);

    _endAlignment = Tween<Alignment>(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ).animate(_controller);

    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _colorIndicatorAnimate = ColorTween(
      begin: Colors.cyanAccent,
      end: Colors.pinkAccent,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Future.delayed(const Duration(seconds: 6), () async {
      if (!mounted) return;

      final data = await getIt<CacheHelper>().getCachedValue(
        CachedKeys.onBoardingKey,
      );

      if (data == true) {
         if(FirebaseAuth.instance.currentUser != null) {
           Navigator.pushReplacementNamed(context, AppRoute.bottomNavigation);
         } else {
          Navigator.pushReplacementNamed(context, AppRoute.authWrapper);
         }
      } else {
        Navigator.pushReplacementNamed(context, AppRoute.onBoarding);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,

      child: _SplashStaticContent(),

      builder: (context, child) {
  return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary, AppColors.pink],
              begin: _beginAlignment.value,
              end: _endAlignment.value,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
  FadeTransition(
                opacity: _fadeInAnimation,
                child: LogoContainer(height: 160.h, width: 160.h, radius: AppSpacing.xl),
              ),
              SizedBox(height: AppSpacing.xxl),

              child!,

  SizedBox(height: AppSpacing.xxxl),

  SizedBox(
                width: 166.w,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.allLG,
                    boxShadow: [
                      BoxShadow(
                        color: _colorIndicatorAnimate.value!.withOpacity(0.9),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: AppRadius.allLG,
                    child: LinearProgressIndicator(
                      minHeight: 6.h,
                      valueColor: _colorIndicatorAnimate,
                      backgroundColor: Colors.black.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xl.h),

  Text(
                "loading your journey..",
                style: AppTextStyles.labelMedium(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SplashStaticContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Text("Sekka", style: AppTextStyles.headlineLarge(context)),
          SizedBox(height: AppSpacing.sm.h),
          Text("Smart Transportation", style: AppTextStyles.labelLarge(context)),
        ],
      ),
    );
  }
}
