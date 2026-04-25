import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Features/Profile/UI/Widgets/edit_profile_content.dart';
import 'package:sekka/Features/Profile/UI/Widgets/edit_profile_footer.dart';
class EditProfileSheet extends StatelessWidget {
  
  const EditProfileSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return DraggableScrollableSheet(
  
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,

      builder: (context, scrollController) {
      
        return Container(

          decoration: BoxDecoration(
       
            color: Colors.white,
       
            borderRadius: BorderRadius.vertical(
       
              top: Radius.circular(28.r),
       
            ),
       
          ),

          child: _buildColumn(scrollController),   
          
          
          
          
           );
      },
    );
  }
 
  Widget _buildColumn(ScrollController scrollController){
     
      return  Column(
            children: [

              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              SizedBox(height: 12),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
                  child: const EditProfileContent(),
                ),
              ),


              const EditProfileFooter(),
            ],

          );

  }
}