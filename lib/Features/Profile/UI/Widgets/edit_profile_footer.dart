import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Cubit/pick_image_cubit.dart';
import 'package:sekka/Core/Cubit/pick_image_state.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Core/Widget/custom_button_core.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/Logic/profile_state.dart';


class EditProfileFooter extends StatelessWidget {
  
  const EditProfileFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.h, 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [

          /// Cancel
          Expanded(
            child: ElevatedButton(

              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(250.w, 45.h),
                backgroundColor: AppColor.offWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(16.r)
                )
              ),
              child: Text("Cancel",style: AppStyle.regular16RobotoBlack,),
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(

            child:BlocListener<PickImageCubit,PickImageState>(
             
              listener: _listenForPickImage,

              child: BlocConsumer<ProfileCubit,ProfileState>(
                
                buildWhen: _buildWhen,

                builder: (context, state) {
              
              return state.profileStateEnum 
              ==ProfileStateEnum.editProfileLoading ?
              Center(
                child: 
              CircularProgressIndicator(
                color: AppColor.main,
              )):CustomButtonCore(
                  onPressed: () => _onPressed(context),
                 width: 250.w 
                , height: 45.h, firstColor: AppColor.main, secondColor: AppColor.secondary
                ,thirdColor: AppColor.pink, text: '' 
                ,alignmentStart: Alignment.centerLeft,alignmentEnd: Alignment.centerRight,
                  child: _buildRowButton(context)
                
                  );               
                },

                listener: _listenForProfile,

                listenWhen: _listenWhenForProfile,

              ),
            ),
            
          ),
        ],
      ),
    );
  }



Widget _buildRowButton(BuildContext context){


return Row(
  mainAxisAlignment: MainAxisAlignment.center,
   children: [
 
    Text(AppText.save,style: AppStyle.regular16RobotoBlack.copyWith(
          color: Colors.white
                                     )),
 SizedBox(width: 10.w,),
 Icon(Icons.save,color: Colors.white,size: 20.sp,)
                    ],
                  );

}


bool _listenWhenForProfile(ProfileState previous, ProfileState current) {
  
  return current.profileStateEnum == ProfileStateEnum.editProfileSuccess  
     || current.profileStateEnum == ProfileStateEnum.editProfileError;
              
}

void _listenForProfile(BuildContext context,ProfileState state)async{
  
   if(state.profileStateEnum == ProfileStateEnum.editProfileSuccess){
                    Navigator.pop(context);
                  }
                  
   if(state.profileStateEnum == ProfileStateEnum.editProfileError){
        FlutterToastHelper.showToast(text: state.errorMsg!,color: AppColor.error);
             }               
  }


Future<void> _listenForPickImage(BuildContext context,PickImageState state) async {


if(state.pickImageEnum==PickImageEnum.uploadImageLoaded){

final model=UpdateUserRequest(

  image: state.imagePathFromSupa,
  clearImage: false,
  name: context.read<ProfileCubit>().nameController.text,
  favTrasnportation: context.read<ProfileCubit>().state.selectedTransports,
  isGetStarted: true
);

  await context.read<ProfileCubit>().editProfile(
    model
  );
  
}else{
  
  if(state.pickImageEnum==PickImageEnum.uploadImageError){

    FlutterToastHelper.showToast(text: state.errorMsg!,color: AppColor.error);
  }
}
}

bool _buildWhen(ProfileState previous, ProfileState current) {
return current.profileStateEnum
  == ProfileStateEnum.editProfileLoading
  || current.profileStateEnum == ProfileStateEnum.editProfileSuccess  
  || current.profileStateEnum == ProfileStateEnum.editProfileError;
                
}

void _onPressed(BuildContext context)async{
  
 if(context.read<ProfileCubit>().formKey.currentState!.validate()){
  if(context.read<PickImageCubit>().state.file!=null){              
    await context.read<PickImageCubit>().uploadImage();
        } 
  else{

    final UpdateUserRequest model = UpdateUserRequest(
      favTrasnportation: context.read<ProfileCubit>().state.selectedTransports,
      name: context.read<ProfileCubit>().nameController.text,
      isGetStarted: true,
      clearImage: context.read<ProfileCubit>().state.isImageRemoved,
    );

    await context.read<ProfileCubit>().editProfile(
          model
                    );
                     }
              
                      
                    }
                                  }
}

