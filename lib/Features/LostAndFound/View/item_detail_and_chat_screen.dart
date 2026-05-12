import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/add_comment_request.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/comments.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found_state.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/chat_bubble.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/chat_input_widget.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/status_badge_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ItemDetailAndChatScreen extends StatefulWidget {

  final ItemModel? item;
  final int? id;

  const ItemDetailAndChatScreen({super.key, this.item, this.id});

  @override
  State<ItemDetailAndChatScreen> createState() => _ItemDetailAndChatScreenState();
}

class _ItemDetailAndChatScreenState extends State<ItemDetailAndChatScreen> {

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.item != null) {
        context.read<LostAndFoundCubit>().getComments(widget.item!.id!);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final maxWidth = isTablet ? 600.0 : double.infinity;

    return BlocConsumer<LostAndFoundCubit, LostFoundState>(
      listener: (context, state) {
            if (state.status == LostFoundStatus.getCommentSuccess ||
            state.status == LostFoundStatus.createCommentSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
        }

            if (state.status == LostFoundStatus.createCommentSuccess || 
            state.status == LostFoundStatus.updateCommentSuccess || 
            state.status == LostFoundStatus.deleteCommentSuccess) {
          context.read<LostAndFoundCubit>().getComments(widget.item!.id!);
          if(state.status != LostFoundStatus.createCommentSuccess) {
             FlutterToastHelper.showToast(text: "Success", color: AppColor.main);
          }
        }

               if (state.status == LostFoundStatus.createCommentFailure ||
            state.status == LostFoundStatus.getCommentFailure ||
            state.status == LostFoundStatus.updateCommentFailure ||
            state.status == LostFoundStatus.deleteCommentFailure) {
          FlutterToastHelper.showToast(
            text: state.errorMsg ?? "Something went wrong",
            color: AppColor.error,
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SizedBox(
                width: maxWidth,
                child: Column(
                  children: [
                    _buildGradientHeader(
                      item?.title ?? 'Loading...',
                      item?.type == ItemType.found,
                      state.comments?.length ?? 0,
                    ),
                    // ItemInfoCardWidget(
                    //   station: item?.stationName ?? "...",
                    //   description: item?.description ?? "...",
                    // ),
                    
                    _buildCommentsSection(state),

                    ChatInputWidget(onSend: (text) async {
                      if (text.trim().isNotEmpty && widget.item != null) {
                        final newComment = AddCommentRequest(
                          userId: FirebaseAuth.instance.currentUser!.uid,
                          commentText: text.trim(),
                          postId: widget.item!.id!,
                        );
                       await  context.read<LostAndFoundCubit>().addComment(newComment);
                        context.read<LostAndFoundCubit>().closeTextField();
                      
                      }
                    }),
                    _buildBeRespectful(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommentsSection(LostFoundState state) {
    final bool isLoading = state.status == LostFoundStatus.getCommmentLoading;

    if (isLoading && (state.comments == null || state.comments!.isEmpty)) {
      return Skeletonizer(enabled: true, child: _buildListViewFake());
    }

    final comments = state.comments ?? [];
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Expanded(
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          final bool isMine = comment.userId == currentUserId;

          return GestureDetector(
            onLongPress: isMine ? () => _showCommentOptions(context, comment) : null,
            child: ChatBubbleWidget(
              messageData: {
                'id': comment.id,
                'senderName': comment.userName,
                'senderAvatar': comment.userImage,
                'message': comment.content,
                'timestamp': comment.createdAt,
                'isMine': isMine
              },
            ),
          );
        },
      ),
    );
  }


void _showCommentOptions(BuildContext context, CommentModel comment) {

  final lostFoundCubit = context.read<LostAndFoundCubit>();

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (innerContext) {

      return BlocProvider.value(
        value: lostFoundCubit,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit_rounded, size: 20.sp, color: AppColor.secondary),
              title: Text(
                'Edit Comment',
                style: AppStyle.regular16RobotoBlack.copyWith(fontSize: 18.sp),
              ),
              onTap: () {
                Navigator.pop(innerContext);
                lostFoundCubit.openTextField(
                  commentId: comment.id!,
                  commentText: comment.content
                ,);  
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline_rounded, size: 20.sp, color: AppColor.error),
              title: Text(
                'Delete Comment',
                style: AppStyle.regular16RobotoBlack.copyWith(fontSize: 18.sp),
              ),
              onTap: () async {

                await lostFoundCubit.deleteComment(comment.id!);
                if (innerContext.mounted) Navigator.pop(innerContext);
              },
            ),

            SizedBox(height: 20.h),
          ],
        ),
      );
    },
  );
}
  Widget _buildListViewFake() {
    return Expanded(
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        itemCount: 6,
        itemBuilder: (context, index) {
          return ChatBubbleWidget(
            messageData: {
              'id': 0,
              'senderName': 'User Name',
              'senderAvatar': "",
              'message': 'Placeholder for skeletonizer to show bubbles.',
              'timestamp': "12:00 PM",
              'isMine': index % 2 == 0
            },
          );
        },
      ),
    );
  }

  Widget _buildGradientHeader(String title, bool isFound, int messageCount) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppStyle.brandGradient),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildArrowBack(),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.regular16RobotoBlack.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              _buildIconMore(),
            ],
          ),
          SizedBox(height: 12.h),
          _buildMessageCount(isFound, messageCount),
        ],
      ),
    );
  }

  Widget _buildArrowBack() => GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Container(
      width: 36.w, height: 36.h,
      decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
      child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20.sp),
    ),
  );

  Widget _buildIconMore() => Container(
    width: 36.w, height: 36.h,
    decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
    child: Icon(Icons.more_vert_rounded, color: Colors.white, size: 20.sp),
  );

  Widget _buildMessageCount(bool isFound, int messageCount) {
    return Row(
      children: [
        StatusBadgeWidget(status: isFound ? PostStatus.found : PostStatus.lost, fontSize: 10.sp),
        SizedBox(width: 8.w),
        Icon(Icons.chat_bubble_outline_rounded, size: 14.sp, color: Colors.white70),
        SizedBox(width: 4.w),
        Text('$messageCount messages', style: TextStyle(fontSize: 12.sp, color: Colors.white70)),
      ],
    );
  }

  Widget _buildBeRespectful() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
      child: Text(
        'Please be respectful and verify item ownership before exchange.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 11.sp, color: AppColor.muted),
      ),
    );
  }
}