import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_image.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Cubit/pick_image_cubit.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/Logic/profile_state.dart';
import 'package:sekka/Features/Profile/UI/Widgets/edit_profile_sheet.dart';
import 'package:sekka/Features/Profile/UI/Widgets/stats_section.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileStack extends StatefulWidget {

  const ProfileStack({super.key});

  @override
  State<ProfileStack> createState() => _ProfileStackState();
}

class _ProfileStackState extends State<ProfileStack> {
  
  static final List<Color> _gradientColors = [
        Colors.white.withOpacity(0.3),
        Colors.white.withOpacity(0.3),
        Colors.white.withOpacity(0.2),
       ];

static final List<BoxShadow> _boxShadows =
[
         BoxShadow(
       color: Colors.black.withOpacity(0.2),
       blurRadius: 25.r,
       spreadRadius: -5.r,
       offset: Offset(0, 20),
      
         ),
         BoxShadow(
       color: Colors.black.withOpacity(0.2),
       blurRadius: 10.r,
       spreadRadius: -6.r,
       offset: Offset(0, 8)
         )
       
];


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(AppImage.profileBackground,height: 224.h,width: double.infinity,fit: BoxFit.cover,),
        _buildProfileGradient(),
        SizedBox(height: 40.h,),
         buildProfileData(),

        Positioned(
          top: 40.h,
          right: 16.w,
          child: _buildEditProfile(),
        ),

          Positioned(top: 180.h,left: 16.w,right: 16.w,child: StatsSection(preferredCount: 3,),),
                
      ],
    );
  }

  Widget buildProfileData(){
    return SafeArea(
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Text(AppText.profile,style: AppStyle.regular16RobotoBlack.copyWith(
              color: Colors.white
            ),
            ),
            SizedBox(height: 16.h,),
            buildProfileDataContent(),
    
          ],
        ),
      ),
    );

    
  }

  




  Widget buildProfileDataContent(){

    return BlocBuilder<ProfileCubit, ProfileState>(
      
      builder: (BuildContext context, state) { 

        return Row(

        children: [
      
   _buildProfileImage(state.userModel?.image??""), 

      SizedBox(width: 16.w,),
      

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Text(state.userModel?.name??AppText.guestUser,style: AppStyle.regular16RobotoBlack.copyWith(color: Colors.white),),
      Text(
        state.userModel?.email ?? state.userModel?.phone ?? AppText.sekkaMember,
        style: AppStyle.regular16RobotoBlack.copyWith(color: Colors.white),
      ),
       
        ]
        ,
      )
      ]);



       },

      
    ) ;
  }

Widget _buildProfileImage(final String image){

return   
      AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        child: Container(
          key: ValueKey("imageSwitcher"),
          height: 80.h,
          width: 80.w,
          decoration: BoxDecoration(
         gradient: LinearGradient(colors: _gradientColors,
         begin: Alignment.topCenter,
         end: Alignment.bottomCenter
         ),
        
         boxShadow: _boxShadows,
        
        borderRadius: BorderRadius.circular(24.r)
        
          ),
          child: image.isNotEmpty?
          ClipRRect(
            borderRadius: BorderRadius.circular(24.r)
          ,child: CachedNetworkImage(
            imageUrl: image, 
          placeholder: (context, url) {
          
            return Skeleton
            
            .keep(keep: true
          
            ,child: Image.asset(AppImage.profileIcon,height: 40.h,width: 40.w,)
            );

          },fit: BoxFit.cover,),
          )
          :Image.asset(AppImage.profileIcon,height: 40.h,width: 40.w,),
        ),
      );
    
}

  Widget _buildProfileGradient(){

return Container(
  height: 224.h,
decoration: BoxDecoration(
  gradient: LinearGradient(
    colors: [
      AppColor.main.withOpacity(0.8),
      AppColor.secondary.withOpacity(0.8),
      AppColor.pink.withOpacity(0.6),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  stops: [0,0.5,1],
  ),
  
),

);
  }

Widget _buildEditProfile(){

return GestureDetector(
  onTap: () {
      _showEditProfileSheet(context);
  },
  child: Container(
    height: 40.h,
    width: 40.w,
    decoration: BoxDecoration(
  gradient: LinearGradient(
    colors: _gradientColors,
           begin: Alignment.topCenter,
           end: Alignment.bottomCenter
           ),
  
      boxShadow: _boxShadows,
  
      borderRadius: BorderRadius.circular(15.r),
    ),
    child: Icon(Icons.edit, 
    size: 25.sp,color: Colors.white,),
  ),
);

}


void _showEditProfileSheet(BuildContext context)async{

final profileCubit=context.read<ProfileCubit>();

return await showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  barrierColor: Colors.black54,
  backgroundColor: Colors.transparent,
  builder: (_) => MultiBlocProvider(providers: [
  
    BlocProvider.value(value: profileCubit),
    BlocProvider(
      create: (context) => getIt<PickImageCubit>(),
    )

  ],child: EditProfileSheet()),
);

}




}