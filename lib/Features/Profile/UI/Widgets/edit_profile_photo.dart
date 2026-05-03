import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_image.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/Logic/profile_state.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../Core/Cubit/pick_image_cubit.dart';


class EditProfilePhoto extends StatelessWidget {
  
  const EditProfilePhoto({super.key});

  @override
  Widget build(BuildContext context) {
   
    final pickCubit = context.read<PickImageCubit>();

    return GestureDetector(
      onTap: () => _showPicker(context, pickCubit),

      child: Stack(

        children: [
          
   
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {

              final networkImage = state.userModel?.image;
              final pickedFile = context.watch<PickImageCubit>().state.file;

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: _buildAvatar(networkImage, pickedFile),
              );
            },
          ),

        
          Positioned(
            bottom: 3,
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 10.r,
              child: Icon(Icons.camera_alt_outlined,
                  size: 17, color: Colors.white),
            ),
          ),

         
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {

              final hasNetworkImage =
                  state.userModel?.image?.isNotEmpty ?? false;
              final hasLocalImage =
                  context.watch<PickImageCubit>().state.file != null;

              if (!hasNetworkImage && !hasLocalImage) {
                return const SizedBox();
              }

              return Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    if (hasLocalImage) {
                      context.read<PickImageCubit>().removeImage();
                    } else {
                      context.read<ProfileCubit>().removeNetworkImage();
                    }
                  },
                  child: CircleAvatar(
                    backgroundColor: AppColor.offWhite,
                    radius: 10.r,
                    child: Icon(Icons.remove,
                        size: 15.sp, color: AppColor.black),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  
  void _showPicker(BuildContext context, PickImageCubit cubit) {
    
    showModalBottomSheet(
      context: context,
     
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.camera, cubit);
              },
            ),

            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(context, ImageSource.gallery, cubit);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(
      BuildContext context, ImageSource source, PickImageCubit cubit) async {
    final profileCubit = context.read<ProfileCubit>();
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source);

    if (image != null && image.path.isNotEmpty) {
      // Any newly selected image means we should not keep "remove network image" intent.
      profileCubit.clearRemovedImageFlag();
      cubit.pickImage(image);
    }
  }

  
  Widget _buildAvatar(String? networkImage, XFile? pickedFile) {
  
    if (pickedFile != null) {
     
      return CircleAvatar(
        key: const ValueKey("local"),
        radius: 35.r,
        backgroundColor: const Color(0xffF1F1F1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.r),
          child: Image.file(
            File(pickedFile.path),
            fit: BoxFit.cover,
            width: 90.w,
            height: 90.h,
          ),
        ),
      );
    }

    
    if (networkImage != null && networkImage.isNotEmpty) {
     
      return CircleAvatar(
        key: const ValueKey("network"),
        radius: 35.r,
        backgroundColor: const Color(0xffF1F1F1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35.r),
          child: CachedNetworkImage(
            height: 70.h,
            width: 70.w,
imageUrl:   networkImage,
fit: BoxFit.cover,

fadeInDuration: Duration(milliseconds: 500),

placeholder: (context, url) => Skeletonizer(
  child:  CircleAvatar(
    radius: 35.r,
    backgroundColor: Color(0xffF1F1F1),
  ),
),

errorWidget: (context, url, error) => const Icon(Icons.error,color: Colors.red,size: 20),
            
          ),
        ),
      );
    }

   
    return CircleAvatar(
      key: const ValueKey("empty"),
      radius: 35.r,
      backgroundColor: const Color(0xffF1F1F1),
      child: Image.asset(
        AppImage.profileIcon,
        width: 40.w,
        height: 40.h,
      ),
    );
  }
}