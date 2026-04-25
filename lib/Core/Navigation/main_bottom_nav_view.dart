import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Core/Helper/notification_helper.dart';
import 'package:sekka/Core/Navigation/animated_nav_item.dart';
import 'package:sekka/Core/Navigation/nav_entities.dart';
import 'package:sekka/Features/LostAndFound/View/item_detail_and_chat_screen.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/UI/profile_screen_view.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Ui/Widget/View/routes_screen_view.dart';


class MainBottomNavView extends StatefulWidget {
  
  const MainBottomNavView({super.key});

  @override
  State<MainBottomNavView> createState() => _MainBottomNavViewState();
}

class _MainBottomNavViewState extends State<MainBottomNavView> {

  @override
  void initState() {

    initNotfication();    
   
    super.initState();
  
  }

void initNotfication()async{

   await getIt<NotificationHelper>().init();

}  

  int _currentIndex = 0;


  static const List<NavItemData> _items = [
    NavItemData(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    NavItemData(
      label: 'Routes',
      icon: Icons.route_outlined,
      activeIcon: Icons.route,
    ),
    NavItemData(
      label: 'Lost & Found',
      icon: Icons.foundation_outlined,
      activeIcon: Icons.route,
    ),
    NavItemData(
      label: 'Alerts',
      icon: Icons.notifications_none_outlined,
      activeIcon: Icons.notifications,
    ),
    NavItemData(
      label: 'Profile',
      icon: Icons.person_outline,
      activeIcon: Icons.person,
    ),
  ];

List<Widget> _buildTabs() {
  return [
    
    Text("Home"),
    
    BlocProvider(
      create: (context) => getIt<RoutesCubit>()..fetchTransports(),
      child: const RoutesScreenView(),
    ),
  
   ItemDetailAndChatScreen(),

    Text('Alerts'),

    BlocProvider(create: (context) => getIt<ProfileCubit>()..getProfile()
    ,child: const ProfileScreenView()),
  
  ];
}

  void _onTabSelected(int index) {

    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _buildTabs(),
      ),
      bottomNavigationBar: Padding(
        padding: NavUiConfig.floatingPadding,
        child: _CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          items: _items,
          onTap: _onTabSelected,
        ),
      ),
    );
  }
}

class _CustomBottomNavigationBar extends StatelessWidget {

  const _CustomBottomNavigationBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  final int currentIndex;
  final List<NavItemData> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: NavUiConfig.navBorderRadius,
        child: BackdropFilter(

          filter: ImageFilter.blur(
            sigmaX: NavUiConfig.blurSigma,
            sigmaY: NavUiConfig.blurSigma,
          ),

          child: _buildContainer()
        ),
      ),
    );
  }
  Widget _buildContainer(){
 return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.offWhite,
              borderRadius: NavUiConfig.navBorderRadius,
              border: Border.all(color: Colors.white.withOpacity(0.45)),
              boxShadow:  const [
  BoxShadow(
  color: Color(0x22000000),
  blurRadius: 20,
  offset: Offset(0, 10),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / items.length;
                return Stack(
                  children: [
                    
                    _buildAnimatedPosition(currentIndex, itemWidth),
                    Row(
                      children: List.generate(items.length, (index) {
                        final item = items[index];
                        final isSelected = currentIndex == index;
                        return Expanded(
                          child: AnimatedNavItem(
                            item: item,
                            isSelected: isSelected,
                            onTap: () => onTap(index),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          );
}

}


Widget _buildAnimatedPosition(int currentIndex, double itemWidth) {

 return  AnimatedPositioned(
                      duration: NavUiConfig.pillDuration,
                      curve: Curves.easeOutCubic,
                      left: currentIndex * itemWidth,
                      top: 0,
                      bottom: 0,
                      width: itemWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.main.withOpacity(0.14),
                            borderRadius: NavUiConfig.activePillBorderRadius,
                          ),
                        ),
                      ),
                    );
                    
                    
}



