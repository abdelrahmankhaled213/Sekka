import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Features/OnBoarding/Ui/Widget/on_boarding_switch.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(

      slivers: [

        SliverToBoxAdapter(
          child: SizedBox(
            height: 151.h,
          ),
        ),
SliverToBoxAdapter(
  child: OnBoardingSwitch(),
)
      ],

    );
  }
}
