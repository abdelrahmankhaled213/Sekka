import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Widget/custom_image_widget.dart';

class ChatBubbleWidget extends StatelessWidget {

  final Map<String, dynamic> messageData;

  const ChatBubbleWidget({super.key, required this.messageData});

  @override
  Widget build(BuildContext context) {

    final isMine = messageData ['isMine'] as bool;
    final message = messageData['message'] as String;
    final timestamp = messageData['timestamp'] as String;
    final senderName = messageData['senderName'] as String;
    final senderAvatar = messageData['senderAvatar'] as String;
    final senderAvatarSemanticLabel =
        messageData['senderAvatarSemanticLabel'] as String?;

    return Padding(

      padding:  EdgeInsets.only(bottom: 16.h),
      
      child: Column(
        crossAxisAlignment: isMine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (!isMine) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                ClipOval(
                  child: CustomImageWidget(
                    imageUrl: senderAvatar,
                    width: 32.w,
                    height: 32.h,
                    fit: BoxFit.cover,
                    semanticLabel: senderAvatarSemanticLabel,
                  ),
                ),

                 SizedBox(width: 8.w),
                
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        senderName,
                        style: AppStyle.w60012RobotoGrey
                      ),

                       SizedBox(height: 3.h),
                       
                      Container(
                        padding:  EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.surface,
                          borderRadius:  BorderRadius.only(
                            topLeft: Radius.circular(4.r),
                            topRight: Radius.circular(16.r),
                            bottomLeft: Radius.circular(16.r),
                            bottomRight: Radius.circular(16.r),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          message,
                          style: AppStyle.w60012RobotoGrey.copyWith(
                            height: 1.5,
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            
                 SizedBox(width: 40.w),
              ],
            ),

             SizedBox(height: 4.h),
            Padding(
              padding:  EdgeInsets.only(left: 40.w),
              child: Text(
                timestamp,
                style: AppStyle.regular11RobotoGrey,
              ),
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                 SizedBox(width: 40.w),
                Flexible(
                  child: Container(
                    padding:  EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppStyle.brandGradient,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(4),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.secondary.withAlpha(51),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      message,
                      style: AppStyle.bold48RobotoWhite.copyWith(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ClipOval(
                  child: CustomImageWidget(
                    imageUrl: senderAvatar,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    semanticLabel: senderAvatarSemanticLabel,
                  ),
                ),
              ],
            ),
            
             SizedBox(height: 4.h),

            Padding(
              padding:  EdgeInsets.only(right: 40.w),
              child: Text(
                timestamp,
                style: AppStyle.regular11RobotoGrey
              ),
            ),
          ],
        ],
      ),
    );
  }
}
