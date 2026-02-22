import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Widget/custom_button_core.dart';
import 'package:sekka/Features/OnBoarding/Ui/Widget/next_or_skip.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../Core/Constants/app_image.dart';
import '../../logic/on_boarding_item.dart';
import 'on_boarding_container.dart';

class OnBoardingSwitch extends StatefulWidget {

  const OnBoardingSwitch({super.key});

  @override
  State<OnBoardingSwitch> createState() => _OnBoardingSwitchState();
}

class _OnBoardingSwitchState extends State<OnBoardingSwitch> {

  var data = <OnBoardingItem>[

    OnBoardingItem(
        message: "Find the fastest routes across Metro, Monorail, and Bus networks with real-time updates",
        title: 'Smart Route Planning',
        secondColorGradient: AppColor.secondary
        ,
        icon: AppImage.metroIcon,
        firstColorGradient: AppColor.main
        ,
        image: AppImage.smartRoutePlaning),


    OnBoardingItem(
        title: "Real-Time Capacity",
        message: "ML-powered predictions show Metro & Monorail capacity before you board. Avoid crowded trains!",
        secondColorGradient: AppColor.pink
        ,
        icon: AppImage.realTimeCapacityIcon
        ,
        firstColorGradient: AppColor.green
        ,
        image: AppImage.realTimeCapacity),


    OnBoardingItem(
        title: "AI Travel Assistant",
        message: "Chat with our smart assistant for route suggestions, fare info, and travel tips",
        secondColorGradient: AppColor.pink
        ,
        icon: AppImage.chatbotIcon
        ,
        firstColorGradient: AppColor.secondary
        ,
        image: AppImage.aiTravelAssistant),


    OnBoardingItem(
        title: "Smart Notifications",
        message: "Get alerts when you're near your station",
        secondColorGradient: AppColor.pink
        ,
        icon: AppImage.smartAlertIcon,
        firstColorGradient: AppColor.orange
        ,
        image: AppImage.smartNotification),

  ];

  late final PageController _controller;

  bool skipDisappear = false;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600.h,
      child: PageView.builder(

          itemCount: data.length,

          itemBuilder: (context, index) {
            return Column(

              children: [

                AnimatedBuilder(animation: _controller,
                  builder: (BuildContext context, Widget? child) {
                    double value = 1;

                    if (_controller.position.haveDimensions) {
                      value = _controller.page! - index;

                      value = (1 - (value.abs() * 0.2)).clamp(0.85, 1);
                    }
                    return Transform.scale(
                        scale: value,
                        child: child
                    );
                  },
                  child: OnBoardingContainer(onBoardingItem: data[index],
                  ),
                ),
                SizedBox(
                  height: 32.h,
                ),
                Text(data[index].title
                  , style: AppStyle.regular18RobotoWhite.copyWith(
                      fontSize: 16.sp,
                      color: AppColor.black
                  ),),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(data[index].message
                    , style: AppStyle.regular16RobotoGrey,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),

                SmoothPageIndicator(
                controller: _controller,
                  effect: WormEffect(

                    dotHeight: 8.h,
                    dotWidth: 8.w,
                    strokeWidth: 1,
                    activeDotColor:
                    data[index].firstColorGradient,
                   type: WormType.thinUnderground
                  ),
                  count: data.length,
                ),

                SizedBox(
                  height: 32.h,
                ),
                NextOrSkip(skipDisappear: skipDisappear,
                  item: data[index],
                  onPressedNext: _onPressedNext,
                  onPressedSkip: _onPressedSkip,)

              ],
            );
          },
          controller: _controller,
          onPageChanged: _onPageChanged

      ),
    );
  }

  void _onPressedNext() {
    if (_controller.page! < data.length - 1) {
      _controller.nextPage(duration: const Duration(
          seconds: 1
      ), curve: Curves.easeInToLinear);
    }
  }

  void _onPressedSkip() {
    if (_controller.page! < data.length - 1) {
      _controller.animateToPage(data.length
          , duration: const Duration(
              seconds: 1
          ), curve: Curves.easeInToLinear);
    }
    else {

    }
  }

  void _onPageChanged(int value) {
    final isLastPage = value == data.length - 1;

    if (skipDisappear != isLastPage) {
      setState(() {
        skipDisappear = isLastPage;
      });
    }
  }
}
