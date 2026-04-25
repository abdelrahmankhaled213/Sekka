import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Features/OnBoarding/logic/on_boarding_item.dart';
import '../../../../Core/Constants/app_style.dart';
import '../../../../Core/Widget/custom_button_core.dart';

class NextOrSkip extends StatelessWidget {

  final OnBoardingItem item;

  final void Function() onPressedSkip;

  final void Function() onPressedNext;

  final bool skipDisappear;

  const NextOrSkip({super.key,required this.skipDisappear
    ,required this.item,required this.onPressedNext
    ,required this.onPressedSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
     padding: EdgeInsets.symmetric(
       horizontal: 16.w
     ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
         children: [

skipDisappear?const SizedBox.shrink():TextButton(onPressed:onPressedSkip,
                 child: Text('Skip',style: AppStyle.regular16RobotoGrey,)),
skipDisappear?Expanded(child: _nextButton()):_nextButton()

              ],
      ),
    );
  }
Widget _nextButton(){
    return CustomButtonCore(
      onPressed: onPressedNext ,
      firstColor: item.firstColorGradient
      , secondColor: item.secondColorGradient
      , text: 'next', width: 150.w, height: 56.h,
      child:_childOfCustomContainerCore()
      ,);

}
  Widget _childOfCustomContainerCore(){
    return   Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[
          Text('Next',
            style: AppStyle.regular18RobotoWhite.copyWith(
                fontSize: 16.sp
            )
            ,

          ),
          SizedBox(
            width: 7.w,
          ),
          Icon(Icons.navigate_next,color: Colors.white,size:20.sp)
        ]
    );
  }
}
