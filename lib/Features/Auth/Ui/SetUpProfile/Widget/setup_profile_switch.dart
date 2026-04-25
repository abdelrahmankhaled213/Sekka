import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Features/Auth/Logic/set_up_profile_cubit.dart';
import 'package:sekka/Features/Auth/Ui/SetUpProfile/Widget/tell_us_about_your_self.dart';
import 'fav_transport.dart';

class SetupProfileSwitch extends StatefulWidget {


  const SetupProfileSwitch({super.key,});

  @override
  State<SetupProfileSwitch> createState() => _SetupProfileSwitchState();
}

class _SetupProfileSwitchState extends State<SetupProfileSwitch> {


 final List<Widget> data = [
   TellUsAboutYourSelf(),
   FavTransport(),
 ];

  @override
  Widget build(BuildContext context) {

   return ExpandablePageView.builder(
loop: true,
   physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,

        itemBuilder: (context, index) {

          return Container(

              padding: EdgeInsets.all(20.sp),

          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r)
          ),
          child:data[index],
          );
        },



        controller: context.read<SetUpProfileCubit>().controller,

    );

  }
 

}

