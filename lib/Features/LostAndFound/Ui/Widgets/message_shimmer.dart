import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';

class MessageShimmer extends StatefulWidget {
  const MessageShimmer({super.key});

  @override
  State<MessageShimmer> createState() => _MessageShimmerState();
}

class _MessageShimmerState extends State<MessageShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    Alignment alignment = Alignment.centerLeft,
  }) {
    return Align(
      alignment: alignment,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (_, __) => Opacity(
          opacity: _animation.value,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: AppColor.muted.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _shimmerBox(width: 220, height: 44),
        const SizedBox(height: 12),
        _shimmerBox(width: 180, height: 44, alignment: Alignment.centerRight),
        const SizedBox(height: 12),
        _shimmerBox(width: 260, height: 60),
        const SizedBox(height: 12),
        _shimmerBox(width: 140, height: 44, alignment: Alignment.centerRight),
        const SizedBox(height: 12),
        _shimmerBox(width: 200, height: 44),
        const SizedBox(height: 12),
        _shimmerBox(width: 160, height: 44, alignment: Alignment.centerRight),
      ],
    );
  }
}

class ConversationShimmer extends StatefulWidget {
  const ConversationShimmer({super.key});

  @override
  State<ConversationShimmer> createState() => _ConversationShimmerState();
}

class _ConversationShimmerState extends State<ConversationShimmer>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => ListView.separated(
        padding: const EdgeInsets.all(16),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, __) => Opacity(
          opacity: _animation.value,
          child: Row(
            children: [

              Container(
                width: 52.w,
                height: 52.h,
                decoration: BoxDecoration(
                  color: AppColor.muted.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
              ),

               SizedBox(width: 12.w),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Container(
                      width: 120.w,
                      height: 14.h,
                      decoration: BoxDecoration(
                        color: AppColor.muted.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                     SizedBox(height: 8.h),
                    
                    Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColor.muted.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}