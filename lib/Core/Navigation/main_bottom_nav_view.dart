import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Cubit/pick_image_cubit.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Features/ChatBot/Ui/View/chat_bot_view.dart';
import 'package:sekka/Features/LostAndFound/Logic/chat_cubit.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:sekka/Features/LostAndFound/View/conversation_screen.dart';
import 'package:sekka/Features/LostAndFound/View/home_feed_screen_view.dart';
import 'package:sekka/Features/NearestStation/Logic/nearest_station_cubit.dart';
import 'package:sekka/Features/NearestStation/Ui/Widget/View/nearest_station_view.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/UI/profile_screen_view.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Ui/Widget/View/routes_screen_view.dart';


class _K {
  const _K._();
  static const Duration pill   = Duration(milliseconds: 320);
  static const Duration icon   = Duration(milliseconds: 260);
  static const Duration tap    = Duration(milliseconds: 180);
  static const Duration slide  = Duration(milliseconds: 350);
  static const BorderRadius nav = BorderRadius.all(Radius.circular(28));
  static const BorderRadius itm = BorderRadius.all(Radius.circular(18));
  static const double blur     = 16;
  static const int centerIndex = 2;
}


class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.isCenter = false,
  });
  final String   label;
  final IconData icon;
  final IconData activeIcon;
  final bool     isCenter;
}


class MainBottomNavView extends StatefulWidget {
  const MainBottomNavView({super.key});

  @override
  State<MainBottomNavView> createState() => _MainBottomNavViewState();
}

class _MainBottomNavViewState extends State<MainBottomNavView> {
  int  _currentIndex = 0;
  bool _isVisible    = true;

  static const List<_NavItem> _items = [
    _NavItem(label: 'Home',         icon: Icons.home_outlined,    activeIcon: Icons.home_rounded),
    _NavItem(label: 'Routes',       icon: Icons.route_outlined,   activeIcon: Icons.route_rounded),
    _NavItem(label: 'Lost & Found', icon: Icons.restore_outlined, activeIcon: Icons.restore_rounded, isCenter: true),
    _NavItem(label: 'Messages',     icon: Icons.message_outlined, activeIcon: Icons.message_rounded),
    _NavItem(label: 'Profile',      icon: Icons.person_outline,   activeIcon: Icons.person_rounded),
  ];

  late final List<Widget> _tabs = [
    BlocProvider(
      create: (_) => getIt<NearestStationCubit>(),
      child: const NearestStationView(),
    ),
    BlocProvider(
      create: (_) => getIt<RoutesCubit>()..fetchTransports(),
      child: const RoutesScreenView(),
    ),
    BlocProvider(
      create: (_) => getIt<LostAndFoundCubit>(),
      child: const HomeFeedScreen(),
    ),
    BlocProvider(
      create: (_) => getIt<ChatCubit>()..getConversations(),
      child: const ConversationsScreen(),
    ),
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
        onNotification: (n) {
          if (n.direction == ScrollDirection.reverse && _isVisible) {
            setState(() => _isVisible = false);
          } else if (n.direction == ScrollDirection.forward && !_isVisible) {
            setState(() => _isVisible = true);
          }
          return true;
        },
        child: IndexedStack(index: _currentIndex, children: _tabs),
      ),
      floatingActionButton: _ChatBotFab(navVisible: _isVisible),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: AnimatedSlide(
        duration: _K.slide,
        curve: Curves.easeInOut,
        offset: _isVisible ? Offset.zero : const Offset(0, 1.5),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _isVisible ? 1.0 : 0.0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
            child: _NavBar(
              currentIndex: _currentIndex,
              items: _items,
              onTap: _onTabSelected,
            ),
          ),
        ),
      ),
    );
  }
}


class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  final int               currentIndex;
  final List<_NavItem>    items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: _K.nav,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _K.blur, sigmaY: _K.blur),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.72),
            borderRadius: _K.nav,
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: List.generate(items.length, (i) {
              final item = items[i];
              if (item.isCenter) {
                return _CenterItem(
                  isSelected: currentIndex == i,
                  onTap: () => onTap(i),
                );
              }
              return Expanded(
                child: _NavItemWidget(
                  item: item,
                  isSelected: currentIndex == i,
                  showBadge: i == 3,
                  onTap: () => onTap(i),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}


class _CenterItem extends StatefulWidget {
  const _CenterItem({required this.isSelected, required this.onTap});
  final bool         isSelected;
  final VoidCallback onTap;

  @override
  State<_CenterItem> createState() => _CenterItemState();
}

class _CenterItemState extends State<_CenterItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: _K.tap,
    lowerBound: 0,
    upperBound: 0.06,
  );

  Future<void> _onTap() async {
    await _ctrl.forward();
    await _ctrl.reverse();
    widget.onTap();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72.w,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) =>
            Transform.scale(scale: 1 - _ctrl.value, child: child),
        child: GestureDetector(
          onTap: _onTap,
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: _K.icon,
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: widget.isSelected
                        ? [AppColor.main, AppColor.secondary]
                        : [
                            AppColor.main.withOpacity(0.8),
                            AppColor.secondary.withOpacity(0.8),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.main
                          .withOpacity(widget.isSelected ? 0.4 : 0.2),
                      blurRadius: widget.isSelected ? 14 : 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  widget.isSelected
                      ? Icons.restore_rounded
                      : Icons.restore_outlined,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 4.h),
              AnimatedDefaultTextStyle(
                duration: _K.icon,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Roboto',
                  color:
                      widget.isSelected ? AppColor.main : AppColor.grey,
                ),
                child: const Text(
                  'Lost & Found',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _NavItemWidget extends StatefulWidget {
  const _NavItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.showBadge = false,
  });

  final _NavItem     item;
  final bool         isSelected;
  final VoidCallback onTap;
  final bool         showBadge;

  @override
  State<_NavItemWidget> createState() => _NavItemWidgetState();
}

class _NavItemWidgetState extends State<_NavItemWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: _K.tap,
    lowerBound: 0,
    upperBound: 0.07,
  );

  Future<void> _onTap() async {
    await _ctrl.forward();
    await _ctrl.reverse();
    widget.onTap();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) =>
          Transform.scale(scale: 1 - _ctrl.value, child: child),
      child: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: _K.pill,
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColor.main.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: _K.itm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: _K.icon,
                    transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim,
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: Icon(
                      widget.isSelected
                          ? widget.item.activeIcon
                          : widget.item.icon,
                      key: ValueKey(widget.isSelected),
                      color: widget.isSelected
                          ? AppColor.main
                          : AppColor.grey,
                      size: 22.sp,
                    ),
                  ),
                  if (widget.showBadge)
                    Positioned(
                      top: -3,
                      right: -6,
                      child: Container(
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                          color: AppColor.main,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 3.h),
              AnimatedDefaultTextStyle(
                duration: _K.icon,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: widget.isSelected
                      ? FontWeight.w700
                      : FontWeight.w500,
                  fontFamily: 'Roboto',
                  color: widget.isSelected ? AppColor.main : AppColor.grey,
                ),
                child: Text(
                  widget.item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatBotFab extends StatefulWidget {
  const _ChatBotFab({required this.navVisible});
  final bool navVisible;

  @override
  State<_ChatBotFab> createState() => _ChatBotFabState();
}

class _ChatBotFabState extends State<_ChatBotFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
    lowerBound: 0,
    upperBound: 0.07,
  );

  Future<void> _onTap() async {
    await _ctrl.forward();
    await _ctrl.reverse();
    if (!mounted) return;
    _openChatBot();
  }

  void _openChatBot() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, __) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0F2F8),
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              Container(
                width: 36.w,
                height: 4.h,
                margin: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              const Expanded(child: ChatBotView()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: _K.slide,
      curve: Curves.easeInOut,
      offset: widget.navVisible ? Offset.zero : const Offset(0, 2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: widget.navVisible ? 1.0 : 0.0,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) =>
              Transform.scale(scale: 1 - _ctrl.value, child: child),
          child: GestureDetector(
            onTap: _onTap,
            child: Container(
              width: 48.w,
              height: 48.w,
              margin: EdgeInsets.only(bottom: 92.h),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColor.main, AppColor.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColor.main.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}