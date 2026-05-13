import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Core/Navigation/nav_entities.dart';
import 'package:sekka/Features/ChatBot/Ui/View/chat_bot_view.dart';
import 'package:sekka/Features/NearestStation/Logic/nearest_station_cubit.dart';
import 'package:sekka/Features/NearestStation/Ui/Widget/View/nearest_station_view.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/UI/profile_screen_view.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Ui/Widget/View/routes_screen_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final items = const [
    NavItemData(label: 'Home',    icon: Icons.home_outlined,          activeIcon: Icons.home_rounded),
    NavItemData(label: 'Routes',  icon: Icons.route_outlined,         activeIcon: Icons.route),
    NavItemData(label: 'Alerts',  icon: Icons.notifications_outlined,  activeIcon: Icons.notifications_rounded),
    NavItemData(label: 'Chat',    icon: Icons.chat_bubble_outline,     activeIcon: Icons.chat_bubble_rounded),
    NavItemData(label: 'Profile', icon: Icons.person_outline,          activeIcon: Icons.person_rounded),
  ];

  List<Widget> get pages => [
    BlocProvider(
      create: (_) => getIt<NearestStationCubit>(),
      child: const NearestStationView(),
    ),
    BlocProvider(
      create: (_) => getIt<RoutesCubit>()..fetchTransports(),
      child: const RoutesScreenView(),
    ),
    const Scaffold(body: Center(child: Text('Alerts'))),
    const ChatBotView(),
    BlocProvider(
      create: (_) => getIt<ProfileCubit>()..getProfile(),
      child: const ProfileScreenView(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: _BottomNav(
        items: items,
        currentIndex: index,
        onTap: (i) {
          HapticFeedback.lightImpact();
          setState(() => index = i);
        },
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<NavItemData> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: const Color(0xFFE5E7EB), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60.h,
          child: Row(
            children: List.generate(items.length, (i) {
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: _NavItem(item: items[i], selected: i == currentIndex),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.item, required this.selected});

  final NavItemData item;
  final bool selected;

  static const _activeColor   = Color(0xFF2B7FFF);
  static const _inactiveColor = Color(0xFF9CA3AF);
  static const _activeBg      = Color(0xFFEBF3FF);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: selected ? _activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Icon(
            selected ? item.activeIcon : item.icon,
            size: 22.sp,
            color: selected ? _activeColor : _inactiveColor,
          ),
        ),
        SizedBox(height: 2.h),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 220),
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? _activeColor : _inactiveColor,
          ),
          child: Text(item.label),
        ),
      ],
    );
  }
}