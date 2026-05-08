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

  final String conversationId;

  const ConversationsScreen({super.key,required this.conversationId});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getConversation(widget.conversationId);
  }

  void _showNewConversationSheet(BuildContext context) {
  
    const dummyUsers = [
      ('user_alpha_001', 'Alex Johnson'),
      ('user_beta_002', 'Maria Garcia'),
      ('user_gamma_003', 'Sam Williams'),
      ('user_delta_004', 'Jordan Lee'),
      ('user_epsilon_005', 'Casey Brown'),
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.background,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<ChatCubit>(),
        child: Padding(
          padding:  EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColor.textSecondary,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              
               SizedBox(height: 20.h),
              
               Text(
                'Start New Conversation',
                style: TextStyle(
                  color: AppColor.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  fontFamily: 'Roboto',
                ),
              ),
               
               SizedBox(height: 16.h),

              ...dummyUsers.map(
                (user) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppColor.main.withOpacity(0.15),
                    child: Text(
                      user.$2[0],
                      style:  TextStyle(
                        color: AppColor.main,
                        fontSize: 16.sp,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  title: Text(
                    user.$2,
                    style:  TextStyle(
                      color: AppColor.textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  subtitle: Text(
                    '${user.$1.substring(0, 12)}...',
                    style:  TextStyle(
                      color: AppColor.textSecondary,
                      fontSize: 12.sp,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    context
                        .read<ChatCubit>()
                        .createConversation(user.$1);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        elevation: 0,
        centerTitle: false,
        title:  Text(
          'Messages',
          style: TextStyle(
            color: AppColor.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        actions: [
          BlocBuilder<ChatCubit, ChatState>(

            builder: (context, state) {
              return IconButton(
                onPressed: state.status == ChatStateEnum.getConversationLoading ? null
                    : () => context
                        .read<ChatCubit>()
                        .getConversations(),
                icon:  Icon(Icons.refresh_rounded, color: AppColor.main,size: 20.sp,),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewConversationSheet(context),
        backgroundColor: AppColor.main,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        child:  Icon(Icons.edit_rounded, color: Colors.white, size: 20.sp),
      ),

      body: BlocConsumer<ChatCubit, ChatState>(

        listener: (context, state) {
          if (state.status==ChatStateEnum.getConversationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMsg ?? "Something went wrong",
                style: AppStyle.regular16RobotoBlack.copyWith(
                  fontSize: 14.sp,
                  color: Colors.white,
                ),),
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
          
          if (state.status== ChatStateEnum.getConversationsLoading) {
            return const ConversationShimmer();
          }

          if (state.status == ChatStateEnum.getConversationSuccess) {
            if (state.conversations!.isEmpty) {
              return _buildEmpty(context);
            }
            return RefreshIndicator(
              color: AppColor.main,
              onRefresh: () =>
                  context.read<ChatCubit>().getConversations(),
              child: ListView.separated(
                padding:  EdgeInsets.all(16.sp),
                itemCount: state.conversations!.length,
                separatorBuilder: (_, __) =>  SizedBox(height: 10.h),
                itemBuilder: (context, index) {
                  final conv = state.conversations![index];
                  return ConversationTile(
                    conversation: conv,
                    currentUserId: currentUserId,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoute.conversation,
                        arguments: conv,
                      );
                    },
                  );
                },
              ),
            );
          }

          if (state.status == ChatStateEnum.getConversationFailure) {
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
            child:  Icon(
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
            'Tap the edit button to start chatting',
            style: TextStyle(color: AppColor.textSecondary, fontSize: 14.sp,fontFamily: 'Roboto'),
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
         
           Icon(Icons.error_outline_rounded,
              color: AppColor.error, size: 48.sp),
         
          SizedBox(height: 16.h),
         
          Text(
            'Something went wrong',
            style:  TextStyle(
              color: AppColor.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 17.sp,
              fontFamily: 'Roboto',
            ),
          ),

           SizedBox(height: 8.h),
          
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              message,
              style:  TextStyle(color: AppColor.textSecondary,fontFamily: 'Roboto',fontSize: 14.sp),
              
              textAlign: TextAlign.center,
            ),
          ),

           SizedBox(height: 20.h),
          
          ElevatedButton(
            onPressed: () =>
                context.read<ChatCubit>().getConversations(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.main,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Try Again',
              style: TextStyle(color: Colors.white,fontFamily: 'Roboto',fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}