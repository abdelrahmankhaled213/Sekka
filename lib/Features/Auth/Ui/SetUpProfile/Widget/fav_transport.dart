import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Cubit/pick_image_cubit.dart';
import 'package:sekka/Core/Cubit/pick_image_state.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/Features/Auth/Ui/SetUpProfile/Widget/select_your_fav_transport.dart';
import 'package:sekka/Features/Auth/Ui/SetUpProfile/Widget/setup_icon_switch.dart';
import 'package:sekka/Features/Auth/Ui/SetUpProfile/Widget/tell_us_button.dart';
import '../../../../../Core/Constants/app_route.dart';
import '../../../../../Core/Constants/app_style.dart';
import '../../../../../Core/Localization/app_localizations.dart';
import '../../../Logic/set_up_profile_cubit.dart';
import '../../../Logic/set_up_profile_state.dart';
import 'backButton.dart';

class FavTransport extends StatefulWidget {
  
  const FavTransport({super.key});

  @override
  State<FavTransport> createState() => _FavTransportState();
}

class _FavTransportState extends State<FavTransport> {


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

void _toggleItem(int index){

  setState(() {

    transports[index]=transports[index].copyWith(

        isSelected: !transports[index].isSelected
    ) ;

  });

}


  @override
  Widget build(BuildContext context) {

  final cubit = context.read<SetUpProfileCubit>();

    return
      Container(

        padding: EdgeInsets.all(10.sp),

        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r)
        ),
        child:

      Column(

      children: [

SetUpIconSwitch(secondColor: AppColor.pink
    , firstColor: AppColor.secondary , icon: Icons.train,),
        SizedBox(
          height: 6.h,
        ),

        Text(context.l10n.preferredTransport
          ,style: AppStyle.regular24RobotoBlack.copyWith(
              fontSize: 16.sp
          ),),
        SizedBox(
          height: 6.h,
        ),

        Text(context.l10n.selectYourFavModeOfTransportation
            ,style: AppStyle.regular16RobotoGrey.copyWith(
                fontSize:14.sp
            )),



        SizedBox(
          height: 14.h,
        ),

    ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: transports.length,
    itemBuilder: (context, index) {
    return TransportCard(
    model: transports[index],
    onTap: () => _toggleItem(index),
    );
    },
    ),

        SizedBox(
          height: 12.h,
        ),

        Row(


          children: [

            Expanded(child: CustomBackButton()),

SizedBox(
  width: 20.w,
),
            BlocListener<PickImageCubit,PickImageState>(

              listener: (context, state) async {

                if(state.pickImageEnum==PickImageEnum.uploadImageLoading){

                await  FlutterToastHelper.showToast(text: AppText.loading,color: AppColor.main);

                }
              if(state.pickImageEnum==PickImageEnum.uploadImageLoaded){


                await uploadRestOfData(context);

                Navigator.pushReplacementNamed(context, AppRoute.bottomNavigation);

              }
              else if(state.pickImageEnum==PickImageEnum.uploadImageError){

               FlutterToastHelper.showToast(text: state.errorMsg??"",color: AppColor.error);

              }

              },

              child: BlocBuilder<SetUpProfileCubit,SetupProfileState>(

                builder: (context, state) {

              if(state.setUpProfileEnum==SetUpProfileEnum.upsertUserLoading){
                
                return Center(
                  child: const CircularProgressIndicator(
                    color: AppColor.main,
                  ),
                );
              }
                return  Expanded(
                    child: TellUsButton(
                      onTap: () => _onPressedNextFav(context),
                      height: 56.h,
                      width: 150.w,
                    ),
                  );
                },

                buildWhen: (previous, current) {

                return current.setUpProfileEnum==
                    SetUpProfileEnum.upsertUserLoading ||
                    current.setUpProfileEnum==
                    SetUpProfileEnum.upsertUserLoaded ||
                    current.setUpProfileEnum==
                    SetUpProfileEnum.upsertUserError;

                },



            )
            )
              ],
        )
      ]
    )
      );
  }

  Future<void> uploadRestOfData(BuildContext context) async {

    final pickImageCubit = context.read<PickImageCubit>();
    final setupProfileCubit = context.read<SetUpProfileCubit>();

    final model = UpdateUserRequest(
      favTrasnportation: setupProfileCubit.chosenType,
      name: setupProfileCubit.nameController.text,
      image: pickImageCubit.state.imagePathFromSupa,
      isGetStarted: true
    );


    await  context.read<SetUpProfileCubit>().upsertUser(model);
  }

  void _onPressedNextFav(BuildContext context) {

    final setUpProfileCubit=context.read<SetUpProfileCubit>();

        _loopForChosenTransport(setUpProfileCubit);
        _validateChosenTransport(context);

      }

  Future<void> _validateChosenTransport( BuildContext context) async {

    final pickImageCubit=  context.read<PickImageCubit>();
   final setupProfileCubit=   context.read<SetUpProfileCubit>();

    if(setupProfileCubit.chosenType.isNotEmpty) {

      if(pickImageCubit.state.file!=null){

  await pickImageCubit.uploadImage();

}else{

uploadRestOfData(context);

        Navigator.pushReplacementNamed(context, AppRoute.bottomNavigation);

}

      
    }
    else{
      FlutterToastHelper.showToast(text: "Please Choose Your Fav",color: AppColor.error);
    }
  }
      
void _loopForChosenTransport(SetUpProfileCubit cubit){
 for (var element in transports) {
   if(element.isSelected){
     cubit.chosenType.add(element.type);
   }
 } 
}

  }
