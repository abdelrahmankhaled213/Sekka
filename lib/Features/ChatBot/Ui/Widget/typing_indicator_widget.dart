import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';

class TypingIndicatorWidget extends StatefulWidget {
  const TypingIndicatorWidget({super.key});

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
          (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 480),
      ),
    );
    _animations = _controllers
        .map(
          (c) => Tween<double>(begin: 0.0, end: -6.0).animate(
        CurvedAnimation(parent: c, curve: Curves.easeInOut),
      ),
    )
        .toList();
    _startAnimation();
  }

  void _startAnimation() async {
    while (mounted) {
      for (int i = 0; i < _controllers.length; i++) {
        if (!mounted) break;
        await Future.delayed(Duration(milliseconds: 110 * i));
        if (!mounted) break;
        _controllers[i].forward().then((_) {
          if (mounted) _controllers[i].reverse();
        });
      }
      await Future.delayed(const Duration(milliseconds: 650));
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (context, _) => Transform.translate(
            offset: Offset(0, _animations[i].value),
            child: Container(
              width: 8.w,
              height: 8.w,
              margin: EdgeInsets.only(right: i < 2 ? 5.w : 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColor.secondary, AppColor.primaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}

class BotTypingBubble extends StatelessWidget {
  const BotTypingBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            margin: EdgeInsets.only(right: 10.w, bottom: 2.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColor.secondary, AppColor.primaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(11.r),
              boxShadow: [
                BoxShadow(
                  color: AppColor.primaryColor.withOpacity(0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.smart_toy_rounded, color: Colors.white, size: 16.sp),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(4.r),
                bottomRight: Radius.circular(20.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const TypingIndicatorWidget(),
          ),
        ],
      ),
    );
  }
}
