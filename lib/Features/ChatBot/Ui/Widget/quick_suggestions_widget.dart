import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';

class QuickSuggestionsWidget extends StatefulWidget {
  final void Function(String) onSuggestionTapped;

  const QuickSuggestionsWidget({super.key, required this.onSuggestionTapped});

  @override
  State<QuickSuggestionsWidget> createState() => _QuickSuggestionsWidgetState();
}

class _QuickSuggestionsWidgetState extends State<QuickSuggestionsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _suggestions = [
    {
      'label': 'Find nearest metro station',
      'icon': Icons.directions_transit_rounded,
      'color': const Color(0xFF155DFC),
    },
    {
      'label': 'Check train capacity',
      'icon': Icons.people_rounded,
      'color': Color(0xFF7B2FF7),
    },
    {
      'label': 'Plan route to airport',
      'icon': Icons.flight_rounded,
      'color': Color(0xFF9810FA),
    },
    {
      'label': 'Show fare information',
      'icon': Icons.payment_rounded,
      'color': Color(0xFF2B7FFF),
    },
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
        );
    Future.delayed(const Duration(milliseconds: 250), () {
      if (mounted) _entranceController.forward();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColor.secondary, AppColor.primaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(7.r),
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Quick questions',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              ...List.generate(
                _suggestions.length,
                    (i) => _SuggestionCard(
                  label: _suggestions[i]['label'] as String,
                  icon: _suggestions[i]['icon'] as IconData,
                  accentColor: _suggestions[i]['color'] as Color,
                  index: i,
                  onTap: () =>
                      widget.onSuggestionTapped(_suggestions[i]['label'] as String),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SuggestionCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color accentColor;
  final int index;
  final VoidCallback onTap;

  const _SuggestionCard({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.index,
    required this.onTap,
  });

  @override
  State<_SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<_SuggestionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 9.h),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTapDown: (_) {
            setState(() => _isPressed = true);
            _pressController.forward();
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
            _pressController.reverse();
            widget.onTap();
          },
          onTapCancel: () {
            setState(() => _isPressed = false);
            _pressController.reverse();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
            decoration: BoxDecoration(
              color: _isPressed
                  ? widget.accentColor.withOpacity(0.06)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: _isPressed
                    ? widget.accentColor.withOpacity(0.4)
                    : const Color(0xFFEAECF0),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_isPressed ? 0.03 : 0.05),
                  blurRadius: _isPressed ? 4 : 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    color: widget.accentColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.accentColor,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  width: 26.w,
                  height: 26.w,
                  decoration: BoxDecoration(
                    color: widget.accentColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: widget.accentColor,
                    size: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
