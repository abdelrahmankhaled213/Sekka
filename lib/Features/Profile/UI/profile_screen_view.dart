import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Features/Profile/UI/Widgets/profile_stack_view.dart';

class ProfileScreenView extends StatelessWidget {
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [

SliverToBoxAdapter(
  child: ProfileStack()
),
SliverToBoxAdapter(
  child: SizedBox(height: 20.h,),
),




    ]);
  }
}