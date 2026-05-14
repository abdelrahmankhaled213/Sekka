import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Widget/custom_image_widget.dart';
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

  static const List<List<Color>> _gradients = [
    [AppColor.main, AppColor.secondary],
    [AppColor.pink, AppColor.secondary],
    [AppColor.green, AppColor.main],
    [AppColor.orange, AppColor.pink],
    [AppColor.lightPurple, AppColor.pink],
  ];

  @override
  Widget build(BuildContext context) {
    
    final isUser1   = conversation.user1Id == currentUserId;
    final otherData = isUser1 ? conversation.user2Data : conversation.user1Data;
    final name      = otherData?.name ?? 'Sekka Member';
    final avatar    = otherData?.image;
    final hasUnread = conversation.unreadCount > 0;
    final lastMsg   = conversation.lastMessage?.text ?? 'No messages yet';
    final gradient  = _gradients[name.codeUnitAt(0) % _gradients.length];
    
    print("last message equals: ${conversation.lastMessage?.text}");
 
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColor.surface,
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

            Stack(
              children: [
                Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: avatar != null
                      ? ClipOval(
                          child: CustomImageWidget(
                            imageUrl: avatar,
                            width: 52.w,
                            height: 52.w,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Text(
                            name[0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20.sp,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                ),
                // online dot
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: AppColor.lightGreen,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColor.surface, width: 2),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            color: AppColor.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            fontFamily: 'Roboto',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        conversation.lastMessageTime.isNotEmpty
                            ? conversation.lastMessageTime
                            : conversation.createdAt,
                        style: TextStyle(
                          color: hasUnread ? AppColor.main : AppColor.muted,
                          fontSize: 11.sp,
                          fontFamily: 'Roboto',
                          fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMsg,
                          style: TextStyle(
                            color: hasUnread
                                ? AppColor.textPrimary
                                : AppColor.textSecondary,
                            fontSize: 13.sp,
                            fontFamily: 'Roboto',
                            fontWeight: hasUnread
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // unread badge
                      if (hasUnread)
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: const BoxDecoration(
                            color: AppColor.main,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              conversation.unreadCount > 99
                                  ? '99+'
                                  : '${conversation.unreadCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        )
                      else
                        // read ticks
                        Icon(
                          conversation.lastMessage?.isRead == true
                              ? Icons.done_all_rounded
                              : Icons.done_rounded,
                          size: 14.sp,
                          color: conversation.lastMessage?.isRead == true
                              ? AppColor.main
                              : AppColor.muted,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}