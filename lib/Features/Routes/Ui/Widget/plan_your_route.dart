import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_image.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Ui/Widget/best_path_destination.dart';

class PlanYourRoute extends StatefulWidget {

  const PlanYourRoute({super.key});

  @override
  State<PlanYourRoute> createState() => _PlanYourRouteState();
}

class _PlanYourRouteState extends State<PlanYourRoute> {

  final List<TransportSwitiching> transportSwitchingList = [

    TransportSwitiching(
      image: AppImage.planYourRouteMetro,
      icon: Icons.train,
      color1: AppColor.darkBlue,
      color2: AppColor.lightBlue,
      title: TransportType.metro,
    ),

    TransportSwitiching(
      image: AppImage.planYourRouteMonorail,
      icon: Icons.directions_railway,
      color1: AppColor.darkPurple,
      color2: AppColor.lightPurple,
      title: TransportType.monorail,
    ),

    TransportSwitiching(
      image: AppImage.planYourRouteBus,
      icon: Icons.directions_bus,
      color1: AppColor.darkGreen,
      color2: AppColor.lightGreen,
      title: TransportType.bus,
    ),
  
  ];

  static LinearGradient _buildGradient(Color color1, Color color2) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color1.withOpacity(0.7),
        color2.withOpacity(0.3),
      ],
      stops: const [1,0],
    );
  }

  @override
  Widget build(BuildContext context) {

    final state = context.watch<RoutesCubit>().state;

    final selectedTransport =
        state.selectedTransportSwitching ?? transportSwitchingList.first;

    return SizedBox(
      height: 380.h,
      child: Stack(
        children: [

          Image.asset(
            selectedTransport.image,
            height: 220.h,
            fit: BoxFit.fill,
            width: double.infinity,
          ),

          Container(
            width: double.infinity,
            height: 220.h,
            decoration: BoxDecoration(
              gradient: _buildGradient(
                selectedTransport.color1,
                selectedTransport.color2,
              ),
            ),
          ),

          Positioned(
            top: 45.h,
            left: 16.w,
            right: 16.w,
            child: BestPathDestination(
              icon: selectedTransport.icon,
            ),
          ),
          Positioned(
            top: 180.h,
            left: 16.w,
            right: 16.w,
            child: _buildChooseTransport(selectedTransport),
          ),
        ],
      ),
    );
  }

Widget _buildChooseTransport(TransportSwitiching selectedTransport) {

  return Container(
   
    padding: EdgeInsets.all(25.sp),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: IntrinsicHeight( 

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          _buildSelectTransportTextAndIcon(),

          SizedBox(height: 16.h),
          
           SingleChildScrollView( 
            scrollDirection: Axis.horizontal,
            child: Row(
              children: transportSwitchingList.map((transport) {
                return _buildTransportSwitchingItem(
                  context,
                  transport,
                  selectedTransport,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}




  Widget _buildTransportSwitchingItem(
    BuildContext context,
    TransportSwitiching transport,
    TransportSwitiching selected,
  ) {
    final isSelected = selected == transport;

        final cubit = context.read<RoutesCubit>();

    return GestureDetector(
      onTap: ()=>
         cubit.changeTransportType(transport),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        padding: EdgeInsets.all(17.sp),
        decoration: BoxDecoration(
          color: isSelected
              ? transport.color1.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected
                ? transport.color1
                : AppColor.grey.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: _buildContent(transport, isSelected),
      ),
    );
  }

  Widget _buildContent(TransportSwitiching transport, bool isSelected) {
    return Column(
      children: [
        Container(
          height: 45.h,
          width: 45.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: isSelected
                ? _buildGradient(transport.color1, transport.color2)
                : null,
            color:
                isSelected ? transport.color1.withOpacity(0.8) : AppColor.offWhite,
          ),
          child: Icon(
            transport.icon,
            color: isSelected ? Colors.white : AppColor.grey,
            size: 24.sp,
          ),
        ),

        SizedBox(height: 6.h),

        Text(
          transport.title.name,
          style: AppStyle.regular16RobotoBlack.copyWith(fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _buildSelectTransportTextAndIcon() {
    return Row(
      children: [
        Icon(context.read<RoutesCubit>().state.selectedTransportSwitching?.icon??Icons.train
        , size: 24.sp, color: context.read<RoutesCubit>().state.selectedTransportSwitching?.color2?? AppColor.darkBlue ),
        SizedBox(width: 8.w),
        Text(
          AppText.selectTransport,
          style: AppStyle.regular16RobotoBlack,
        ),
      ],
    );
  }
}

class TransportSwitiching {
  
  final String image;
  final IconData icon;
  final Color color1;
  final Color color2;
  final TransportType title;

  TransportSwitiching({
    required this.image,
    required this.icon,
    required this.color1,
    required this.color2,
    required this.title,
  });
}