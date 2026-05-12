import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_image.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/Features/Routes/Data/Model/Transport.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Logic/routes_state.dart';
import 'package:sekka/Features/Routes/Ui/Widget/paginated_search_dropdown.dart';
import 'package:sekka/Features/Routes/Ui/Widget/plan_your_route.dart';
import 'package:sekka/Features/Routes/Ui/Widget/replace_stations.dart';
import 'package:sekka/Features/Routes/Ui/Widget/routes_button.dart';
import 'package:sekka/Features/Routes/Ui/Widget/routes_widget.dart';
import 'package:sekka/Features/Routes/Ui/Widget/transfer.dart';
import 'package:sekka/core/constants/app_color.dart';



class RoutesBody extends StatefulWidget {
  
  const RoutesBody({super.key});

  @override
  State<RoutesBody> createState() => _RoutesBodyState();
}

class _RoutesBodyState extends State<RoutesBody> {

  
  @override
  Widget build(BuildContext context) {

 
    return 

         CustomScrollView(

          slivers: [
            SliverToBoxAdapter(

              child: PlanYourRoute(),
            )
            ,

        SliverToBoxAdapter(

    child: Container(
      
      padding: EdgeInsets.all(25.sp),
      
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      
          
          child: Column(

          
            children: [
            
            
        Row(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            
            Image.asset(AppImage.locationIcon,height: 24.h,width: 24.w,color: context.read<RoutesCubit>().state.selectedTransportSwitching?.color1??AppColor.darkBlue,),
            SizedBox(width: 8.w,),
            Text(AppText.journeyDetails,style:AppStyle.regular16RobotoBlack ,),
          
          ],
        ),

        SizedBox(height: 20.h,),

               _buildDropDown(context,
               controller: context.read<RoutesCubit>().selectedStartController,
            text: AppText.selectMetroStart,
            isStart: true,
            onSelected: _onSelectedStart),
          
        
        
        SizedBox(height: 4.h,),
        
        
         ReplaceStations(),
        
        
         SizedBox(height: 4.h,),
      
        _buildDropDown(controller: context.read<RoutesCubit>().selectedEndController
        ,context
            ,text: AppText.selectMetroEnd,
            isStart: false,
            onSelected: _onSelectedEnd),


     SizedBox(height: 22.h,),   
     

BlocListener<RoutesCubit, RoutesState>(

  listener: _onstateListener,
  listenWhen: _listenWhen,
  child: BlocBuilder<RoutesCubit, RoutesState>(
  buildWhen: (previous, current) =>
        previous.routesStateEnum != current.routesStateEnum,
      
        builder: (context, state) {
  
      final routesCubit = context.read<RoutesCubit>();

    final isSelectedStartOrEnd=routesCubit.selectedStartController.text.isNotEmpty&&routesCubit
    .selectedEndController.text.isNotEmpty;
    
      return Column(

        children: [

          AnimatedOpacity(
            opacity: isSelectedStartOrEnd? 1
                : 0.4,
            duration: const Duration(milliseconds: 500),
            child: RoutesButton(
              label: AppText.search,
              onPressed: () => isSelectedStartOrEnd? _onPressed(context):null,
              gradient: LinearGradient(
                colors: [
                  routesCubit.state.selectedTransportSwitching?.color2 ?? AppColor.lightBlue,
                  routesCubit.state.selectedTransportSwitching?.color1 ?? AppColor.darkBlue,
                ],
              ),
            ),
          ),
  

           SizedBox(height: 10.h),
  
       AnimatedSwitcher(
  duration: const Duration(milliseconds: 500),
  child: () {
    switch (state.routesStateEnum) {

      case RoutesStateEnum.gettingRoutePathLoading:
        return CircularProgressIndicator(
          key: const ValueKey("loading"),
          color: context
                  .read<RoutesCubit>().state
                  .selectedTransportSwitching
                  ?.color1 ??
              AppColor.darkBlue,
        );

      case RoutesStateEnum.gettingRoutePathLoaded:
        return ListView.builder(
          key: const ValueKey("list"),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.segments.length,
          itemBuilder: (context, i) {
            final segment = state.segments[i];

            switch (segment.type) {
              case TransportType.transfer:
                return TransferWidget(
                 segment: segment,
                                                     );

              default:
                return RouteWidget(segment: segment);
            }
          },
        );

      default:
        return const SizedBox.shrink(key: ValueKey("empty"));
    }
  }(),
) 
       
        ],
      );
    },
  ),
)

           ],
            ),
           
           
    ),
        ),
        ],        
        );
  }


void _onstateListener(BuildContext context,RoutesState state) {
  
  if(state.routesStateEnum==RoutesStateEnum.gettingRoutePathError){

    FlutterToastHelper.showToast(text: state.errorMessage!,color: AppColor.error);
  }
}

bool _listenWhen(RoutesState previous, RoutesState current) {
  return previous.routesStateEnum!=current.routesStateEnum && 
  current.routesStateEnum==RoutesStateEnum.gettingRoutePathError;
}
Future<void> _onPressed(BuildContext context) async {
  await context.read<RoutesCubit>().getRoutePath();
}
  Widget _buildDropDown(
    BuildContext context,
    {
  required String text,
  required Function(Transport transport,BuildContext context) onSelected,
  required bool isStart,
  required TextEditingController controller
  }) {

    return  
           
             PaginatedSearchDropdown(
              controller: controller,
              isStart: isStart,
              hint: text,
              isLoading: context.watch<RoutesCubit>().state.isSearchLoading!|| context.watch<RoutesCubit>().state.isLoading,
              hasMore: context.watch<RoutesCubit>().state.hasMore,
              onLoadMore: () => _onLoadMore(context),
              onSearch: (text) => _onSearch(context, text),
              onSelected: (transport) => onSelected(transport,context)
            );
          
        
    
  }

  Future<void> _onSearch(BuildContext context, String text) async {
  await context.read<RoutesCubit>().searchMetros(searchText: text);
}

Future<void> _onLoadMore(BuildContext context) async {
  await context.read<RoutesCubit>().fetchTransports();
}

  void _onSelectedStart(Transport transport,BuildContext context) {

 context.read<RoutesCubit>().selectMetroStart(transport);
  }

   void _onSelectedEnd(Transport transport,BuildContext context) {

 context.read<RoutesCubit>().selectMetroEnd(transport);
  }
}