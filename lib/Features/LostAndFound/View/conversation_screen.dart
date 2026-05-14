import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Widget/custom_image_widget.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/conversation.dart';
import 'package:sekka/Features/LostAndFound/Logic/chat_cubit.dart';
import 'package:sekka/Features/LostAndFound/Logic/chat_state.dart';

class ConversationsScreen extends StatelessWidget {
  
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColor.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            _SearchBar(),
            Expanded(child: _Body(currentUserId: currentUserId)),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Messages',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
              color: AppColor.textPrimary,
              letterSpacing: -0.4,
            ),
          ),
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              if (state.status == ChatStateEnum.getConversationsLoading) {
                return SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColor.main,
                  ),
                );
              }
              return GestureDetector(
                onTap: () => context.read<ChatCubit>().getConversations(),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: AppColor.offWhite,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.refresh_rounded,
                    color: AppColor.grey,
                    size: 18.sp,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}


class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColor.outline, width: 0.8),
        ),
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: AppColor.muted, size: 17.sp),
            SizedBox(width: 8.w),
            Text(
              'Search conversations...',
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'Roboto',
                color: AppColor.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _Body extends StatelessWidget {
  final String currentUserId;
  const _Body({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state.status == ChatStateEnum.getConversationsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.errorMsg ?? 'Something went wrong',
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
          return _ConversationShimmer();
        }
        if (state.status == ChatStateEnum.getConversationsFailure) {
          return _ErrorView(
            message: state.errorMsg ?? 'Something went wrong',
            onRetry: () => context.read<ChatCubit>().getConversations(),
          );
        }
        if (state.conversations == null || state.conversations!.isEmpty) {
          return _EmptyView();
        }
        return RefreshIndicator(
          color: AppColor.main,
          onRefresh: () => context.read<ChatCubit>().getConversations(),
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
            itemCount: state.conversations!.length,
            itemBuilder: (context, index) {
              final conv = state.conversations![index];
              return _ConversationTile(
                conversation: conv,
                currentUserId: currentUserId,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoute.chat,
                  arguments: {
                    'conversationId': conv,
                    'userId': conv.user1Id == currentUserId
                        ? conv.user2Id
                        : conv.user1Id,
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}


class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  final String currentUserId;
  final VoidCallback onTap;

  const _ConversationTile({
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

    final isUser1    = conversation.user1Id == currentUserId;
    final otherData  = isUser1 ? conversation.user2Data : conversation.user1Data;
    final name       = otherData?.name ?? 'Sekka Member';
    final hasUnread  = (conversation.unreadCount ?? 0) > 0;
    final gradient   = _gradients[name.codeUnitAt(0) % _gradients.length];

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 4.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColor.outline, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: otherData?.image != null
                      ? ClipOval(
                          child: CustomImageWidget(
                            imageUrl: otherData!.image!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Text(
                            name[0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 17.sp,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                ),
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: Container(
                    width: 11.w,
                    height: 11.w,
                    decoration: BoxDecoration(
                      color: AppColor.lightGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColor.background,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto',
                          color: AppColor.textPrimary,
                        ),
                      ),
                      Text(
                        conversation.lastMessageTime,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontFamily: 'Roboto',
                          color: AppColor.muted,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.lastMessage?.text??'',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: 'Roboto',
                            color: hasUnread
                                ? AppColor.textPrimary
                                : AppColor.textSecondary,
                            fontWeight: hasUnread
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (hasUnread) ...[
                        SizedBox(width: 6.w),
                        Container(
                          width: 18.w,
                          height: 18.w,
                          decoration: const BoxDecoration(
                            color: AppColor.main,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${conversation.unreadCount}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                        ),
                      ],
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

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: AppColor.main.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppColor.main,
              size: 32.sp,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Roboto',
              color: AppColor.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Start a conversation with someone!',
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'Roboto',
              color: AppColor.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}


class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, color: AppColor.error, size: 48.sp),
            SizedBox(height: 16.h),
            Text(
              'Something went wrong',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'Roboto',
                color: AppColor.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 13.sp,
                fontFamily: 'Roboto',
                color: AppColor.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColor.main,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Try Again',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _ConversationShimmer extends StatefulWidget {
  @override
  State<_ConversationShimmer> createState() => _ConversationShimmerState();
}

class _ConversationShimmerState extends State<_ConversationShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _anim = Tween(begin: 0.4, end: 0.9).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => ListView.builder(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
        itemCount: 5,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.symmetric(vertical: 11.h),
          child: Row(
            children: [
              _box(48.w, 48.w, 24.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _box(120.w, 13.h, 6.r),
                    SizedBox(height: 7.h),
                    _box(200.w, 11.h, 6.r),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _box(double w, double h, double r) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: AppColor.outline.withOpacity(_anim.value),
          borderRadius: BorderRadius.circular(r),
        ),
      );
}