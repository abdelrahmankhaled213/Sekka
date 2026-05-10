import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // مهمة عشان ScrollDirection
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Cubit/pick_image_cubit.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Features/LostAndFound/Logic/chat_cubit.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:sekka/Features/LostAndFound/View/conversation_screen.dart';
import 'package:sekka/Features/LostAndFound/View/home_feed_screen_view.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/UI/profile_screen_view.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Ui/Widget/View/routes_screen_view.dart';

class _NavUiConfig {
  const _NavUiConfig._();

  static const EdgeInsets floatingPadding = EdgeInsets.fromLTRB(16, 0, 16, 16);
  static const BorderRadius navBorderRadius = BorderRadius.all(Radius.circular(24));
  static const BorderRadius itemBorderRadius = BorderRadius.all(Radius.circular(18));
  static const BorderRadius activePillBorderRadius = BorderRadius.all(Radius.circular(16));
  static const Duration pillDuration = Duration(milliseconds: 320);
  static const Duration iconDuration = Duration(milliseconds: 260);
  static const Duration tapDuration = Duration(milliseconds: 220);
  static const double blurSigma = 14;
  static const double pressScale = 0.08;
}

class MainBottomNavView extends StatefulWidget {
  
  const MainBottomNavView({super.key});

  @override
  State<MainBottomNavView> createState() => _MainBottomNavViewState();
}

class _MainBottomNavViewState extends State<MainBottomNavView> {
  
  int _currentIndex = 0;
  bool _isVisible = true; 

  List<_NavItemData> get _items => [
        _NavItemData(label: AppText.home, icon: Icons.home_outlined, activeIcon: Icons.home),
        _NavItemData(label: AppText.search, icon: Icons.search_outlined, activeIcon: Icons.search),
        _NavItemData(label: AppText.trips, icon: Icons.route_outlined, activeIcon: Icons.route),
        _NavItemData(
          label: AppText.alerts,
          icon: Icons.notifications_none_outlined,
          activeIcon: Icons.notifications,
        ),
        _NavItemData(label: AppText.profile, icon: Icons.person_outline, activeIcon: Icons.person),
      ];

  late final List<Widget> _tabs = [
    
    const _ComingSoonTab(icon: Icons.notifications_active_outlined, title: null),
    
     BlocProvider(create: (_) => getIt<RoutesCubit>()..fetchTransports()
    , child: const RoutesScreenView()),

     BlocProvider(create: (_) => getIt<LostAndFoundCubit>(), child: const HomeFeedScreen()),

     BlocProvider(create: (_) => getIt<ChatCubit>()..getConversations(), child: const ConversationsScreen()),

    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProfileCubit>()..getProfile()),
        BlocProvider(create: (_) => getIt<PickImageCubit>()),
      ],
      child: const ProfileScreenView(),
    ),
  ];

  void _onTabSelected(int index) {
    
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
    
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.reverse) {
            if (_isVisible) setState(() => _isVisible = false);
          } else if (notification.direction == ScrollDirection.forward) {
            if (!_isVisible) setState(() => _isVisible = true);
          }
          return true;
        },
        child: IndexedStack(index: _currentIndex, children: _tabs),
      ),
      
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        height: _isVisible ? 110.h : 0, 
        child: Wrap( 
          children: [
            Padding(
              padding: _NavUiConfig.floatingPadding,
              child: _CustomBottomNavigationBar(
                currentIndex: _currentIndex,
                items: _items,
                onTap: _onTabSelected,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonTab extends StatelessWidget {

  const _ComingSoonTab({required this.icon, required this.title});
  final IconData icon;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            gradient: LinearGradient(
              colors: [
                AppColor.main.withOpacity(0.12),
                AppColor.secondary.withOpacity(0.1),
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: AppColor.main.withOpacity(0.16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30.r,
                backgroundColor: AppColor.main.withOpacity(0.15),
                child: Icon(icon, color: AppColor.main, size: 30.sp),
              ),
              SizedBox(height: 14.h),
              Text(
                title ?? AppText.comingSoon,
                style: AppStyle.regular24RobotoBlack,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.h),
              Text(
                AppText.featureUnderPreparation,
                style: AppStyle.regular16RobotoGrey,
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
  final List<_NavItemData> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {

    if (items.isEmpty) return const SizedBox.shrink();

    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: _NavUiConfig.navBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _NavUiConfig.blurSigma, sigmaY: _NavUiConfig.blurSigma),
          child: Container(
            padding:  EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.68),
              borderRadius: _NavUiConfig.navBorderRadius,
              border: Border.all(color: Colors.white.withOpacity(0.45)),
              boxShadow: const [
                BoxShadow(color: Color(0x22000000), blurRadius: 20, offset: Offset(0, 10)),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / items.length;
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: _NavUiConfig.pillDuration,
                      curve: Curves.easeOutCubic,
                      left: currentIndex * itemWidth,
                      top: 0,
                      bottom: 0,
                      width: itemWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.main.withOpacity(0.14),
                            borderRadius: _NavUiConfig.activePillBorderRadius,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(items.length, (index) {
                        final item = items[index];
                        return Expanded(
                          child: _AnimatedNavItem(
                            item: item,
                            isSelected: currentIndex == index,
                            onTap: () => onTap(index),
                          ),
                        );
                      }),
                    ),
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

class _AnimatedNavItem extends StatefulWidget {
  const _AnimatedNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavItemData item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem> with SingleTickerProviderStateMixin {
  
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _NavUiConfig.tapDuration,
    lowerBound: 0.0,
    upperBound: _NavUiConfig.pressScale,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onTap() async {

    await _controller.forward();
    await _controller.reverse();
    widget.onTap();
  
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(scale: 1 - _controller.value, child: child),
      child: InkWell(
        borderRadius: _NavUiConfig.itemBorderRadius,
        onTap: _onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: const BoxDecoration(color: Colors.transparent, borderRadius: _NavUiConfig.activePillBorderRadius),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: _NavUiConfig.iconDuration,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: Icon(
                  widget.isSelected ? widget.item.activeIcon : widget.item.icon,
                  key: ValueKey<bool>(widget.isSelected),
                  color: widget.isSelected ? AppColor.main : AppColor.grey,
                ),
              ),
              SizedBox(height: 4.h),
              AnimatedDefaultTextStyle(
                duration: _NavUiConfig.iconDuration,
                curve: Curves.easeOut,
                style: TextStyle(
                  fontSize: widget.isSelected ? 12 : 11,
                  fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isSelected ? AppColor.main : AppColor.grey,
                ),
                child: Text(widget.item.label, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
}
