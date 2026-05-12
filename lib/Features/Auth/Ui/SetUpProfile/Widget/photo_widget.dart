import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sekka/Core/Cubit/pick_image_state.dart';
import '../../../../../Core/Cubit/pick_image_cubit.dart';



class PhotoWidget extends StatelessWidget {

  const PhotoWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final cubit = context.read<PickImageCubit>();

    return GestureDetector(
      onTap: () => _showPicker(context, cubit),
      child: Stack(
        children: [
          BlocBuilder<PickImageCubit, PickImageState>(

            builder: (context, state) {

              final imagePath = state.imagePath??'';

              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),

                child: imagePath.isEmpty
                    ? const CircleAvatar(
                  key: ValueKey("empty"),
                  radius: 40,
                  backgroundColor: Color(0xffF1F1F1),
                  child: Icon(Icons.person,
                      color: Colors.grey, size: 38),
                )
                    : CircleAvatar(
                  key: ValueKey("image"),
                  radius: 40,
                  backgroundColor: Color(0xffF1F1F1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.file(
                      File(imagePath),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
              title:  Text("Camera",
                ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, cubit);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title:  Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, cubit);
              },
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _pickImage(
      ImageSource source, PickImageCubit cubit) async {

    final picker = ImagePicker();

    final image = await picker.pickImage(source: source);

    if (image != null && image.path.isNotEmpty) {

      cubit.pickImage(image);

    }
  }
}