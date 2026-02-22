import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_style.dart';

class CustomButtonCore extends StatelessWidget{

  final void Function() onPressed;
  final String text;
  final double height;
  final double width;
  final Color firstColor;
  final Color secondColor;
  final Widget child;
  const CustomButtonCore({super.key
    ,required this.onPressed,required this.width 
    ,required this.height,
  required this.firstColor,
  required this.secondColor,
    required this.text,
    required this.child
  });

@override
  Widget build(BuildContext context) {

return GestureDetector(
  onTap: onPressed,
  child: Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          offset: Offset(0,4),
          blurRadius: 4

        ),

      ],
       borderRadius: BorderRadius.circular(16.r),
       gradient: LinearGradient(colors: [
    firstColor.withOpacity(0.8),
    firstColor.withOpacity(0.8),
    secondColor.withOpacity(0.85)
      ]
      ,stops: [0,0.5,1],begin: Alignment.topCenter
      ,end: Alignment.bottomCenter
    ),
    ),
    child:child

    ),
);
  }

}