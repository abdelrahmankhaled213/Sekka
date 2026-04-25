import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';


class ReplaceStations extends StatelessWidget {
  
  const ReplaceStations({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed:  ()=>
          context.read<RoutesCubit>().replaceMetroStations(),
        
       icon: Icon(Icons.swap_vert_outlined
          ,size: 20.sp,color: AppColor.grey,)),
    );

  }
}