import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sekka/Features/Routes/Ui/Widget/plan_your_route.dart';


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