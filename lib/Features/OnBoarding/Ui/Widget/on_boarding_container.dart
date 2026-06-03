import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/core/theme/app_radius.dart';
import 'package:sekka/core/theme/app_spacing.dart';
import '../../logic/on_boarding_item.dart';

class OnBoardingContainer extends StatelessWidget {

  final OnBoardingItem onBoardingItem;

  const OnBoardingContainer({super.key,required this.onBoardingItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 256.h,
      margin: AppSpacing.horizontalLG,
decoration: BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.25),
      offset: Offset(0, 25),
      blurRadius: 50,
      spreadRadius: -12,
    ),
  ],
  
),
child: Stack(
  fit: StackFit.expand,
  children: [
  ClipRRect(
        borderRadius: AppRadius.allXXL,
        child: Image.asset(onBoardingItem.image, fit: BoxFit.cover),
      ),

    Container(
      decoration: BoxDecoration(

        gradient: LinearGradient(colors: [
          onBoardingItem.firstColorGradient.withOpacity(0.8),
          onBoardingItem.firstColorGradient.withOpacity(0.8),
          onBoardingItem.secondColorGradient.withOpacity(0.85)
        ]
            ,stops: [0,0.5,1],begin: Alignment.topCenter
            ,end: Alignment.bottomCenter),

  borderRadius: AppRadius.allXXXL,

      ),
    ),

  Center(child: Image.asset(onBoardingItem.icon, height: 80.h, width: 80.w))
  ],
),
    );
  }
}
