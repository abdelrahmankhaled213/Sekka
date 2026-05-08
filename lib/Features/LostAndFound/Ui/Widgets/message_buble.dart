import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/message.dart';

class MessageBubble extends StatelessWidget {

  final Message message;
  final bool isSentByMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        margin: EdgeInsets.only(
          top: 2.h,
          bottom: 2.h,
          left: isSentByMe ? 48.w : 0,
          right: isSentByMe ? 0 : 48.w,
        ),
        padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSentByMe ? AppColor.muted : AppColor.surface,
          borderRadius: BorderRadius.only(
            topLeft:  Radius.circular(18.r),
            topRight:  Radius.circular(18.r),
            bottomLeft: Radius.circular(isSentByMe ? 18.r : 4.r),
            bottomRight: Radius.circular(isSentByMe ? 4.r : 18.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: isSentByMe ? Colors.white : AppColor.textPrimary,
                fontSize: 15.sp,
                height: 1.4,
              ),
            ),

             SizedBox(height: 3.h),
            
            Text(
              message.createdAt,
              style: TextStyle(
                color: isSentByMe
                    ? Colors.white.withOpacity(0.7)
                    : AppColor.textSecondary,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}