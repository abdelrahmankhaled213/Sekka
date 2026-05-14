import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Features/ChatBot/Data/Model/chat_message_model.dart';
import 'package:sekka/Features/ChatBot/Ui/Widget/typing_indicator_widget.dart';

class ChatMessagesWidget extends StatelessWidget {
  final List<ChatMessageModel> messages;
  final bool isTyping;
  final ScrollController scrollController;

  const ChatMessagesWidget({
    super.key,
    required this.messages,
    required this.isTyping,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      itemCount: messages.length + (isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (isTyping && index == messages.length) {
          return const BotTypingBubble();
        }
        return _AnimatedMessageBubble(
          key: ValueKey(messages[index].id),
          message: messages[index],
          index: index,
        );
      },
    );
  }
}

class _AnimatedMessageBubble extends StatefulWidget {
  final ChatMessageModel message;
  final int index;

  const _AnimatedMessageBubble({
    super.key,
    required this.message,
    required this.index,
  });

  @override
  State<_AnimatedMessageBubble> createState() => _AnimatedMessageBubbleState();
}

class _AnimatedMessageBubbleState extends State<_AnimatedMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(widget.message.isBot ? -0.08 : 0.08, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    final delay = (widget.index * 55).clamp(0, 350);
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: _MessageBubble(message: widget.message),
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isBot = message.isBot;

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment:
        isBot ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment:
            isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isBot)
                Container(
                  width: 34.w,
                  height: 34.w,
                  margin: EdgeInsets.only(right: 10.w, bottom: 2.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColor.secondary, AppColor.primaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(11.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primaryColor.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.smart_toy_rounded,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.70,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isBot ? Colors.white : null,
                    gradient: isBot
                        ? null
                        : LinearGradient(
                      colors: [AppColor.secondary, AppColor.primaryColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                      bottomLeft: Radius.circular(isBot ? 4.r : 20.r),
                      bottomRight: Radius.circular(isBot ? 20.r : 4.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isBot
                            ? Colors.black.withOpacity(0.06)
                            : AppColor.primaryColor.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w400,
                      color: isBot ? AppColor.textPrimary : Colors.white,
                      height: 1.55,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 5.h,
              left: isBot ? 44.w : 0,
              right: isBot ? 0 : 4.w,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
              isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
              children: [
                Text(
                  message.timestamp,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    color: AppColor.muted,
                  ),
                ),
                if (!isBot) ...[
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.done_all_rounded,
                    size: 13.sp,
                    color: AppColor.primaryColor,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
