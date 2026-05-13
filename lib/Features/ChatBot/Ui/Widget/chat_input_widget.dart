import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';

class ChatInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String) onSend;

  const ChatInputWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _sendPulseController;
  late Animation<double> _sendScaleAnimation;
  bool _hasText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _sendPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _sendScaleAnimation = Tween<double>(begin: 1.0, end: 0.90).animate(
      CurvedAnimation(parent: _sendPulseController, curve: Curves.easeInOut),
    );
    widget.controller.addListener(_onTextChanged);
    widget.focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
  }

  void _onFocusChanged() {
    setState(() => _isFocused = widget.focusNode.hasFocus);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    widget.focusNode.removeListener(_onFocusChanged);
    _sendPulseController.dispose();
    super.dispose();
  }

  void _handleSend() async {
    if (!_hasText) return;
    await _sendPulseController.forward();
    await _sendPulseController.reverse();
    widget.onSend(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
          if (_isFocused)
            BoxShadow(
              color: AppColor.primaryColor.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: _isFocused
                      ? AppColor.primaryColor.withOpacity(0.5)
                      : const Color(0xFFE8EAF0),
                  width: _isFocused ? 1.5 : 1.0,
                ),
                boxShadow: _isFocused
                    ? [
                  BoxShadow(
                    color: AppColor.primaryColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
                    : [],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: widget.focusNode,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (value) {
                        if (value.trim().isNotEmpty) _handleSend();
                      },
                      style: TextStyle(
                        fontSize: 13.5.sp,
                        color: AppColor.textPrimary,
                        height: 1.4,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Ask me anything about your trip...',
                        hintStyle: TextStyle(
                          fontSize: 13.5.sp,
                          color: AppColor.muted,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(18.w, 12.h, 8.w, 12.h),
                        isDense: true,
                      ),
                      maxLines: 4,
                      minLines: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.w, bottom: 10.h),
                    child: AnimatedOpacity(
                      opacity: _hasText ? 0.0 : 0.6,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.attach_file_rounded,
                        color: AppColor.muted,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10.w),
          ScaleTransition(
            scale: _sendScaleAnimation,
            child: GestureDetector(
              onTap: _handleSend,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _hasText
                        ? [AppColor.secondary, AppColor.primaryColor]
                        : [const Color(0xFFDDE1EA), const Color(0xFFDDE1EA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: _hasText
                      ? [
                    BoxShadow(
                      color: AppColor.primaryColor.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : [],
                ),
                child: Center(
                  child: AnimatedRotation(
                    turns: _hasText ? -0.08 : 0,
                    duration: const Duration(milliseconds: 220),
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 19.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
