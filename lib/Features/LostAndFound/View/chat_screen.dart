import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/conversation.dart';
import 'package:sekka/Features/LostAndFound/Logic/chat_cubit.dart';
import 'package:sekka/Features/LostAndFound/Logic/chat_state.dart';

class ChatScreen extends StatefulWidget {
  final String otherUserId;
  final Conversation conversation;

  const ChatScreen({
    super.key,
    required this.conversation,
    required this.otherUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textCtrl   = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _canSend     = false;

  String get _myId => FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _textCtrl.addListener(() {
      final v = _textCtrl.text.trim().isNotEmpty;
      if (v != _canSend) setState(() => _canSend = v);
    });
    final cubit = context.read<ChatCubit>();
    cubit.listenToMessages(widget.conversation.id);
    cubit.markMessagesAsRead(widget.conversation.id);
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final txt = _textCtrl.text.trim();
    if (txt.isEmpty) return;
    _textCtrl.clear();
    context.read<ChatCubit>().sendMessage(widget.conversation.id, txt);
  }

  @override
  Widget build(BuildContext context) {
    final isUser1   = widget.conversation.user1Id == _myId;
    final otherData = isUser1
        ? widget.conversation.user2Data
        : widget.conversation.user1Data;
    final otherName = otherData?.name ?? 'Sekka Member';

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: _buildAppBar(otherName, otherData?.image),
      body: Column(
        children: [
          Expanded(child: _buildMessages()),
          _buildInputBar(),
        ],
      ),
    );
  }


  PreferredSizeWidget _buildAppBar(String name, String? avatar) {
    return AppBar(
      backgroundColor: AppColor.surface,
      elevation: 0,
      titleSpacing: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Divider(height: 0.5, color: AppColor.outline),
      ),
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: AppColor.main,
          size: 20.sp,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          _Avatar(name: name, imageUrl: avatar, size: 36),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                  color: AppColor.textPrimary,
                ),
              ),
              Text(
                'Online',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontFamily: 'Roboto',
                  color: AppColor.lightGreen,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert_rounded, color: AppColor.muted, size: 22.sp),
          onPressed: () {},
        ),
      ],
    );
  }


  Widget _buildMessages() {
    
    return BlocConsumer<ChatCubit, ChatState>(

      listener: (_, state) {
        if (state.status == ChatStateEnum.getMessagesSuccess) _scrollToBottom();
      },
      builder: (context, state) {
        if (state.status == ChatStateEnum.getMessagesLoading &&
            state.messages == null) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColor.main,
              strokeWidth: 2,
            ),
          );
        }
        if (state.messages?.isEmpty ?? true) {
          return Center(
            child: Text(
              'Say hello 👋',
              style: TextStyle(
                color: AppColor.textSecondary,
                fontSize: 16.sp,
                fontFamily: 'Roboto',
              ),
            ),
          );
        }
        return ListView.builder(
          controller: _scrollCtrl,
          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 8.h),
          itemCount: state.messages!.length,
          itemBuilder: (context, i) {
            final msg        = state.messages![i];
            final isMine     = msg.senderId == _myId;
            final senderData = msg.senderId == widget.conversation.user1Id
                ? widget.conversation.user1Data
                : widget.conversation.user2Data;
            final name       = senderData?.name ?? 'Sekka Member';

            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: isMine
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!isMine) ...[
                    _Avatar(
                      name: name,
                      imageUrl: senderData?.image,
                      size: 26,
                    ),
                    SizedBox(width: 7.w),
                  ],
                  Column(
                    crossAxisAlignment: isMine
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      // Bubble
                      Container(
                        constraints: BoxConstraints(maxWidth: 0.65.sw),
                        padding: EdgeInsets.symmetric(
                          horizontal: 13.w,
                          vertical: 9.h,
                        ),
                        decoration: BoxDecoration(
                          color: isMine ? AppColor.main : AppColor.surface,
                          borderRadius: BorderRadius.only(
                            topLeft:     Radius.circular(16.r),
                            topRight:    Radius.circular(16.r),
                            bottomLeft:  Radius.circular(isMine ? 16.r : 4.r),
                            bottomRight: Radius.circular(isMine ? 4.r  : 16.r),
                          ),
                          border: isMine
                              ? null
                              : Border.all(
                                  color: AppColor.outline,
                                  width: 0.5,
                                ),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: 'Roboto',
                            color: isMine
                                ? Colors.white
                                : AppColor.textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      // Time + read ticks
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            msg.createdAt,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontFamily: 'Roboto',
                              color: AppColor.muted,
                            ),
                          ),
                          if (isMine) ...[
                            SizedBox(width: 3.w),
                            Icon(
                              msg.isRead
                                  ? Icons.done_all_rounded
                                  : Icons.done_rounded,
                              size: 13.sp,
                              color: msg.isRead
                                  ? AppColor.main
                                  : AppColor.muted,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  if (isMine) SizedBox(width: 4.w),
                ],
              ),
            );
          },
        );
      },
    );
  }





  Widget _buildInputBar() {
    return Container(
      color: AppColor.surface,
      padding: EdgeInsets.fromLTRB(14.w, 8.h, 14.w, 14.h),
      child: SafeArea(
        child: Row(
          children: [
            Icon(Icons.attach_file_rounded, color: AppColor.muted, size: 22.sp),
            SizedBox(width: 10.w),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColor.offWhite,
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: TextField(
                  controller: _textCtrl,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: 'Roboto',
                    color: AppColor.textPrimary,
                  ),
                  maxLines: 4,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'Roboto',
                      color: AppColor.muted,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _canSend ? AppColor.main : AppColor.offWhite,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: _canSend ? _sendMessage : null,
                icon: Icon(
                  Icons.send_rounded,
                  color: _canSend ? Colors.white : AppColor.muted,
                  size: 17.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime? t) {
    if (t == null) return '';
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }
}


class _Avatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;

  const _Avatar({
    required this.name,
    required this.size,
    this.imageUrl,
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
    final gradient = _gradients[name.codeUnitAt(0) % _gradients.length];

    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: imageUrl != null
          ? ClipOval(child: Image.network(imageUrl!, fit: BoxFit.cover))
          : Center(
              child: Text(
                name[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: (size * 0.38).sp,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
    );
  }
}