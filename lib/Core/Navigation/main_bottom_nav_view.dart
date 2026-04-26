import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Core/Navigation/nav_entities.dart';
import 'package:sekka/Features/LostAndFound/View/home_feed_screen_view.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/UI/profile_screen_view.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Ui/Widget/View/routes_screen_view.dart';
import 'package:sekka/main.dart' as AppColor;

class MainScreen extends StatefulWidget {

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final items = const [
    NavItemData(label: 'Home', icon: Icons.home_outlined, activeIcon: Icons.home),
    NavItemData(label: 'Routes', icon: Icons.route_outlined, activeIcon: Icons.route),
    NavItemData(label: 'Lost', icon: Icons.foundation_outlined, activeIcon: Icons.foundation),
    NavItemData(label: 'Alerts', icon: Icons.notifications_none, activeIcon: Icons.notifications),
    NavItemData(label: 'Profile', icon: Icons.person_outline, activeIcon: Icons.person),
  ];

  final pages =  [
Text("Home"), 
BlocProvider( create: (context) => getIt<RoutesCubit>()..fetchTransports()
, child: const RoutesScreenView(), ) 
, HomeFeedScreen() 
, Text('Alerts') 
, BlocProvider(create: (context) => getIt<ProfileCubit>()..getProfile() 
,child: const ProfileScreenView()),


  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: FloatingBottomNav(
        items: items,
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
      ),
    );
  }
}




class FloatingBottomNav extends StatelessWidget {
  const FloatingBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<NavItemData> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.fromLTRB(16.h, 0.w, 16.h, 18.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            height: 70.h,
            padding:  EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.85),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(.4)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 25,
                  offset: Offset(0, 10),
                )
              ],
            ),
            child: LayoutBuilder(
              builder: (context, c) {
                final itemWidth = c.maxWidth / items.length;
                return Stack(
                  children: [
                    _AnimatedPill(
                      left: itemWidth * currentIndex,
                      width: itemWidth,
                    ),
                    Row(
                      children: List.generate(items.length, (index) {
                        final selected = index == currentIndex;
                        return Expanded(
                          child: _NavItem(
                            item: items[index],
                            selected: selected,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              onTap(index);
                            },
                          ),
                        );
                      }),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
  
}
class _AnimatedPill extends StatelessWidget {
  final double left;
  final double width;

  const _AnimatedPill({required this.left, required this.width});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      left: left,
      top: 0,
      bottom: 0,
      width: width,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(.15),
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
    );
  }
}
class _NavItem extends StatelessWidget {
  final NavItemData item;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
              child: Icon(
                selected ? item.activeIcon : item.icon,
                key: ValueKey(selected),
                size: selected ? 27 : 22,
                color: selected ? Colors.blue : Colors.grey,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: TextStyle(
                fontSize: selected ? 12.sp : 11.sp,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.blue : Colors.grey,
              ),
              child: Text(item.label),
            )
          ],
        ),
      ),
    );
  }
}