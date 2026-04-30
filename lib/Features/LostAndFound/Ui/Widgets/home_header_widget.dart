import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_style.dart';

class HomeHeaderWidget extends StatelessWidget {
  
  final VoidCallback onAddPressed;

  const HomeHeaderWidget({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppStyle.brandGradient),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [

            Positioned(
              top: 0,
              right: -5,
              child: _buildContainerShapes(height: 120.h, width:120.w)
            ),

            Positioned(
              bottom: 10,
              left: 60,
              child:_buildContainerShapes(height: 60.h, width:60.w)
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
              child:_buildRow()
            ),

           _addPostIcon()    
                
              
            ]
            ),
          
        ),
      );
    
  }


Widget _buildRow(){
return  Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withAlpha(77),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.inventory_2_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildColumnText()
                  ),
                ],
              );
}

Widget _buildContainerShapes({
  required double height,
  required double width,
}){

return Container(
       width: width,
       height: height,
       decoration: BoxDecoration(
       shape: BoxShape.circle,
       color: Colors.white.withAlpha(15),
                ),
              );
}

  Widget _buildColumnText(){
   return  Column(
   crossAxisAlignment: CrossAxisAlignment.start,
   children: [
                        Text(
                          'Lost & Found',
                          style:AppStyle.regular18RobotoWhite.copyWith(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          'Help each other find lost items',
                          style: AppStyle.regular18RobotoWhite.copyWith(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withAlpha(217),
                          ),
                        ),
                      ],
                    );
  }
  Widget _addPostIcon(){
    return GestureDetector(
  onTap: onAddPressed,
  child: Align(
    alignment: Alignment.topRight,
    child: Container(
    width: 40.w,
    height: 40.h,
    decoration: BoxDecoration(
    color: Colors.white.withAlpha(51),
    shape: BoxShape.circle,
     border: Border.all(
     color: Colors.white.withAlpha(102),
      width: 1.5,
                        ),
                        ),
                        child:  Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 22.sp,
                        ),
                      ),
  ),
                  );

  }
}
