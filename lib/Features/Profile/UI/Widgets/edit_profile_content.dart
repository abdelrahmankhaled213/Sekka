import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Localization/app_localizations.dart';
import 'package:sekka/Core/Widget/custom_text_field.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/Features/Auth/Ui/SetUpProfile/Widget/select_your_fav_transport.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/Logic/profile_state.dart';
import 'package:sekka/Features/Profile/UI/Widgets/edit_profile_photo.dart';

class EditProfileContent extends StatefulWidget {

  const EditProfileContent({super.key});

  @override
  State<EditProfileContent> createState() => _EditProfileContent();
}

class _EditProfileContent extends State<EditProfileContent> {


  List<TransportModel> transports = [

    TransportModel(
      title: "Metro",
      subtitle: "Real-time capacity tracking",
      icon: Icons.train,
      isSelected: false, type: TransportType.metro,
    ),
    TransportModel(
      title: "Bus",
      subtitle: "Live bus tracking",
      icon: Icons.directions_bus,
      isSelected: false, type: TransportType.bus,
    ),
    TransportModel(
      title: "Monorail",
      subtitle: "ML-powered predictions",
      icon: Icons.bolt,
      isSelected: false,
      type: TransportType.monorail
    ),
    TransportModel(
      title: "Microbus",
      subtitle: "Quick local routes",
      icon: Icons.airport_shuttle,
      type: TransportType.microbus,
      isSelected: false
    ),
  ];


  
  @override
  void initState() {

  WidgetsBinding.instance.addPostFrameCallback((_) {
  final cubit = context.read<ProfileCubit>();
  final user = cubit.state.userModel;

  cubit.nameController.text = user?.name ?? "";
  cubit.initSelectedTransport(user?.favTrasnportation ?? []);

});

  

      super.initState();
  }

  @override
  Widget build(BuildContext context) {
   
    return Padding(
      padding: EdgeInsetsGeometry.all(10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
Center(
  child: Text(
    AppText.editProfile,
    style: AppStyle.regular16RobotoBlack,
  ),
),

SizedBox(
  height: 20.h,
),

Text(
  AppText.profilePicture,
  style: AppStyle.regular16RobotoBlack,
),

SizedBox(
  height: 20.h,
),

EditProfilePhoto(),
        
        SizedBox(
          height: 20.h,
        ),

Text(
  AppText.fullName,
  style: AppStyle.regular16RobotoBlack,
),

          Form(
            key: context.read<ProfileCubit>().formKey,
            child: Align(
              alignment: Alignment.centerLeft,
              child: MyTextFormField(
              validator: (value) {
                if(value==null||value.isEmpty){
                  return context.l10n.enterYourName;
                }
                return null;
              }
              ,prefixIcon: Icon(Icons.person,color: AppColor.grey,size: 20.sp,),
            
              controller: context.read<ProfileCubit>().nameController
                  , hint: context.l10n.enterYourName,),
            ),
          ),

        SizedBox(
          height: 20.h,
        ),

Text(AppText.preferredTransport,style: AppStyle.regular16RobotoBlack,),

        SizedBox(
          height: 20.h,
        ),

BlocBuilder<ProfileCubit, ProfileState>(
  builder: (context, state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transports.length,
      itemBuilder: (context, index) {

        final isSelected = state.selectedTransports
            .contains(transports[index].type);

        return TransportCard(
          model: transports[index].copyWith(isSelected: isSelected),
          onTap: () {
            context.read<ProfileCubit>()
                .toggleTransport(transports[index].type);
          },
        );
      },
    );
  },
),
      ],
      ),
    );
  }
}