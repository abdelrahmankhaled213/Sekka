import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Features/LostAndFound/Logic/chat_cubit.dart';
import 'package:sekka/Features/LostAndFound/Logic/chat_state.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/conversation_tile.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/message_shimmer.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
 

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Messages',
          style: TextStyle(
            color: AppColor.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
            fontSize: 22.sp,
          ),
        ),
        actions: [
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              if (state.status == ChatStateEnum.getConversationsLoading) {
                return MessageShimmer();
              }

              return IconButton(
                onPressed: () => context.read<ChatCubit>().getConversations(),
                icon: Icon(Icons.refresh_rounded, color: AppColor.muted, size: 20.sp),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state.status == ChatStateEnum.getConversationsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMsg ?? "Something went wrong",
                  style: AppStyle.regular16RobotoBlack.copyWith(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: AppColor.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ChatStateEnum.getConversationsLoading) {
            return const ConversationShimmer();
          }

          if (state.status == ChatStateEnum.getConversationsSuccess) {
            if (state.conversations == null || state.conversations!.isEmpty) {
              return _buildEmpty(context);
            }
            return RefreshIndicator(
              color: AppColor.main,
              onRefresh: () => context.read<ChatCubit>().getConversations(),
              child: ListView.separated(
                padding: EdgeInsets.all(16.sp),
                itemCount: state.conversations!.length,
                separatorBuilder: (_, __) => SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final conv = state.conversations![index];
                  return ConversationTile(
                    conversation: conv,
                    currentUserId: currentUserId,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoute.chat,
                        arguments: {
                          'conversationId': conv.id,
                          // تحديد ID الطرف الآخر ديناميكيًا
                          'userId': conv.user1Id == currentUserId 
                              ? conv.user2Id 
                              : conv.user1Id,
                        },
                      );
                    },
                  );
                },
              ),
            );
          }

          if (state.status == ChatStateEnum.getConversationsFailure) {
            return _buildError(context, state.errorMsg ?? "Something went wrong");
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: AppColor.main.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppColor.main,
              size: 36.sp,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'No conversations yet',
            style: TextStyle(
              color: AppColor.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Start a conversation with someone!',
            style: TextStyle(
              color: AppColor.textSecondary,
              fontSize: 14.sp,
              fontFamily: 'Roboto',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, color: AppColor.error, size: 48.sp),
          SizedBox(height: 16.h),
          Text(
            'Oops! Something went wrong',
            style: TextStyle(
              color: AppColor.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 17.sp,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              message,
              style: TextStyle(
                color: AppColor.textSecondary,
                fontFamily: 'Roboto',
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () => context.read<ChatCubit>().getConversations(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.main,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(color: Colors.white, fontFamily: 'Roboto'),
            ),
          ),
        ],
      ),
    );
  }
}