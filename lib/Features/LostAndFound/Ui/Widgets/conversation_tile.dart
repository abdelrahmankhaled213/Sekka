import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/conversation.dart';
class ConversationTile extends StatelessWidget {

  final Conversation conversation;
  final String currentUserId;
  final VoidCallback onTap;

  const ConversationTile({
    super.key,
    required this.conversation,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final otherUserId = conversation.otherUserId(currentUserId);
    final shortId = otherUserId.length > 8
        ? otherUserId.substring(0, 8).toUpperCase()
        : otherUserId.toUpperCase();
    final initial = shortId.isNotEmpty ? shortId[0] : '?';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [

            Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                gradient: AppStyle.brandGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initial,
                  style:  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),

             SizedBox(width: 14.w),
            

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'User $shortId',
                        style: const TextStyle(
                          color: AppColor.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        conversation.createdAt,
                        style:  TextStyle(
                          color: AppColor.textSecondary,
                          fontSize: 12.sp,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),

                   SizedBox(height: 4.h),

                   Text(
                    'Tap to open conversation',
                    style: TextStyle(
                      color: AppColor.textSecondary,
                      fontSize: 13.sp,
                      fontFamily: 'Roboto',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
           
             SizedBox(width: 8.w),
           
           Icon(
              Icons.chevron_right_rounded,
              color: AppColor.muted,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  
}