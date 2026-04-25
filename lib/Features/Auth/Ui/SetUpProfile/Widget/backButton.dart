import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Features/Auth/Logic/set_up_profile_cubit.dart';

import '../../../../../Core/Constants/app_color.dart';

class CustomBackButton extends StatelessWidget {


  const CustomBackButton({super.key,});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => _backToPrevious(context),

        style: ElevatedButton.styleFrom(
          fixedSize: Size(150.w,56.h),
          backgroundColor: AppColor.offWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(16.r)
          )
        )
        , child: Text('Back',style: 
        AppStyle.regular18RobotoWhite.copyWith(
        fontSize:   16.sp,
          color: AppColor.grey
        ),));
  }
  void _backToPrevious(BuildContext context){
    final cubit = context.read<SetUpProfileCubit>();
    cubit.goPreviousPage();
  }
}
