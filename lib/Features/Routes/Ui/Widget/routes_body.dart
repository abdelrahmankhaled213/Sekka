import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_image.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
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
         ],        
                );
  }

}