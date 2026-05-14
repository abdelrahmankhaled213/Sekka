import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/conversation.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/message.dart';
import 'package:sekka/Features/LostAndFound/Logic/chat_cubit.dart';
import 'package:sekka/Features/LostAndFound/Logic/chat_state.dart';

class ChatScreen extends StatefulWidget {
  final String otherUserId;
  final Conversation? conversation;
  final ItemModel? item;
  const ChatScreen({
    super.key,
    this.conversation,
    required this.otherUserId,
    this.item,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _textCtrl   = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _canSend     = false;
  Message? _editingMessage;


  Conversation? _conversation;

  String get _myId => FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;

    _textCtrl.addListener(() {
      final v = _textCtrl.text.trim().isNotEmpty;
      if (v != _canSend) setState(() => _canSend = v);
    });

    if (_conversation != null) {
      final cubit = context.read<ChatCubit>();
      cubit.listenToMessages(_conversation!.id);
      cubit.markMessagesAsRead(_conversation!.id);
      cubit.setCurrentChat(_conversation!.id);
    }
  }

  @override
  void dispose() {
    context.read<ChatCubit>().setCurrentChat(null);
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

  void _sendOrUpdate() {
    final txt = _textCtrl.text.trim();
    if (txt.isEmpty) return;
    _textCtrl.clear();

    final cubit = context.read<ChatCubit>();

    if (_editingMessage != null) {
      cubit.updateMessage(_editingMessage!.id, txt);
      setState(() => _editingMessage = null);
    } else if (_conversation == null) {
       cubit.createConversationAndSend(widget.otherUserId, txt);
    } else {
      cubit.sendMessage(_conversation!.id, txt);
    }
  }

  void _startEdit(Message msg) {
    setState(() => _editingMessage = msg);
    _textCtrl.text = msg.text;
    _textCtrl.selection = TextSelection.fromPosition(
      TextPosition(offset: _textCtrl.text.length),
    );
  }

  void _cancelEdit() {
    setState(() => _editingMessage = null);
    _textCtrl.clear();
  }

  void _showMessageOptions(BuildContext context, Message msg) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColor.surface,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.w,
              height: 4.h,
              margin: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColor.outline,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit_outlined, color: AppColor.main, size: 20.sp),
              title: Text('Edit message',
                  style: TextStyle(fontSize: 14.sp, fontFamily: 'Roboto', color: AppColor.textPrimary)),
              onTap: () {
                Navigator.pop(context);
                _startEdit(msg);
              },
            ),
            Divider(height: 0.5, color: AppColor.outline),
            ListTile(
              leading: Icon(Icons.delete_outline_rounded, color: AppColor.error, size: 20.sp),
              title: Text('Delete message',
                  style: TextStyle(fontSize: 14.sp, fontFamily: 'Roboto', color: AppColor.error)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(context, msg);
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Message msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text('Delete message',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600,
                fontFamily: 'Roboto', color: AppColor.textPrimary)),
        content: Text('Are you sure you want to delete this message?',
            style: TextStyle(fontSize: 14.sp, fontFamily: 'Roboto', color: AppColor.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppColor.textSecondary, fontFamily: 'Roboto', fontSize: 14.sp)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ChatCubit>().deleteMessage(msg.id);
            },
            child: Text('Delete',
                style: TextStyle(color: AppColor.error, fontFamily: 'Roboto',
                    fontWeight: FontWeight.w600, fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
 
  String otherName   = widget.item?.userName ?? 'Sekka Member';
  String? otherAvatar = widget.item?.userImage;

 
  if (_conversation != null) {
    final isUser1   = _conversation!.user1Id == _myId;
    final otherData = isUser1 ? _conversation!.user2Data : _conversation!.user1Data;
    otherName   = otherData?.name  ?? widget.item?.userName  ?? 'Sekka Member';
    otherAvatar = otherData?.image ?? widget.item?.userImage;
  }
 
    return BlocListener<ChatCubit, ChatState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status == ChatStateEnum.createConversationAndSendSuccess) {
          setState(() => _conversation = state.conversation);
        }

        if (state.status == ChatStateEnum.deleteMessageFailure ||
            state.status == ChatStateEnum.updateMessageFailure ||
            state.status == ChatStateEnum.sendMessageFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMsg ?? 'Something went wrong'),
              backgroundColor: AppColor.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: _buildAppBar(otherName, otherAvatar),
        body: Column(
          children: [
            Expanded(child: _buildMessages()),
            if (_editingMessage != null) _buildEditBar(),
            _buildInputBar(),
          ],
        ),
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
        icon: Icon(Icons.arrow_back_ios_rounded, color: AppColor.main, size: 20.sp),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          _Avatar(name: name, imageUrl: avatar, size: 36),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto', color: AppColor.textPrimary)),
              Text('Online',
                  style: TextStyle(fontSize: 11.sp, fontFamily: 'Roboto', color: AppColor.lightGreen)),
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

  Widget _buildEditBar() {
    return Container(
      color: const Color(0xFFEFF6FF),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(Icons.edit_outlined, color: const Color(0xFF1D4ED8), size: 16.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text('Editing message',
                style: TextStyle(fontSize: 12.sp, fontFamily: 'Roboto', color: const Color(0xFF1D4ED8))),
          ),
          GestureDetector(
            onTap: _cancelEdit,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: const BoxDecoration(color: Color(0xFFBFDBFE), shape: BoxShape.circle),
              child: Icon(Icons.close_rounded, size: 12.sp, color: const Color(0xFF1D4ED8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    // ✅ لو مفيش conversation لسه — شاشة فاضية
    if (_conversation == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline_rounded,
                color: AppColor.muted, size: 48.sp),
            SizedBox(height: 12.h),
            Text('Send a message to start chatting',
                style: TextStyle(color: AppColor.textSecondary,
                    fontSize: 14.sp, fontFamily: 'Roboto')),
          ],
        ),
      );
    }

    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (_, state) {
        if (state.status == ChatStateEnum.getMessagesSuccess) _scrollToBottom();
        
        if (state.status == ChatStateEnum.createConversationAndSendSuccess) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        if (state.status == ChatStateEnum.getMessagesLoading && state.messages == null) {
          return Center(child: CircularProgressIndicator(color: AppColor.main, strokeWidth: 2));
        }
        if (state.status == ChatStateEnum.sendMessageLoading && _conversation == null) {
          return Center(child: CircularProgressIndicator(color: AppColor.main, strokeWidth: 2));
        }
        if (state.messages?.isEmpty ?? true) {
          return Center(
            child: Text('Say hello 👋',
                style: TextStyle(color: AppColor.textSecondary, fontSize: 16.sp, fontFamily: 'Roboto')),
          );
        }
        return ListView.builder(
          controller: _scrollCtrl,
          padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 8.h),
          itemCount: state.messages!.length,
          itemBuilder: (context, i) {
            final msg        = state.messages![i];
            final isMine     = msg.senderId == _myId;
            final senderData = _conversation == null
                ? null
                : msg.senderId == _conversation!.user1Id
                    ? _conversation!.user1Data
                    : _conversation!.user2Data;
            final name       = senderData?.name ?? 'Sekka Member';
            final isEditing  = _editingMessage?.id == msg.id;

            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  if (!isMine) ...[
                    _Avatar(name: name, imageUrl: senderData?.image, size: 26),
                    SizedBox(width: 7.w),
                  ],
                  Column(
                    crossAxisAlignment: isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onLongPress: isMine ? () => _showMessageOptions(context, msg) : null,
                        child: AnimatedOpacity(
                          opacity: isEditing ? 0.5 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 0.65.sw),
                            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
                            decoration: BoxDecoration(
                              color: isMine
                                  ? (isEditing ? AppColor.main.withOpacity(0.7) : AppColor.main)
                                  : AppColor.surface,
                              borderRadius: BorderRadius.only(
                                topLeft:     Radius.circular(16.r),
                                topRight:    Radius.circular(16.r),
                                bottomLeft:  Radius.circular(isMine ? 16.r : 4.r),
                                bottomRight: Radius.circular(isMine ? 4.r  : 16.r),
                              ),
                              border: isMine ? null : Border.all(color: AppColor.outline, width: 0.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(msg.text,
                                    style: TextStyle(fontSize: 13.sp, fontFamily: 'Roboto',
                                        color: isMine ? Colors.white : AppColor.textPrimary, height: 1.5)),
                                if (msg.isEdited)
                                  Text('edited',
                                      style: TextStyle(fontSize: 10.sp, fontFamily: 'Roboto',
                                          color: isMine ? Colors.white60 : AppColor.muted)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(msg.createdAt,
                              style: TextStyle(fontSize: 10.sp, fontFamily: 'Roboto', color: AppColor.muted)),
                          if (isMine) ...[
                            SizedBox(width: 3.w),
                            Icon(
                              msg.isRead ? Icons.done_all_rounded : Icons.done_rounded,
                              size: 13.sp,
                              color: msg.isRead ? AppColor.main : AppColor.muted,
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
    final isEditing = _editingMessage != null;
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
                  style: TextStyle(fontSize: 13.sp, fontFamily: 'Roboto', color: AppColor.textPrimary),
                  maxLines: 4,
                  minLines: 1,
                  decoration: InputDecoration(
                    hintText: isEditing ? 'Edit message...' : 'Type a message...',
                    hintStyle: TextStyle(fontSize: 13.sp, fontFamily: 'Roboto', color: AppColor.muted),
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
                color: _canSend
                    ? (isEditing ? AppColor.green : AppColor.main)
                    : AppColor.offWhite,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: _canSend ? _sendOrUpdate : null,
                icon: Icon(
                  isEditing ? Icons.check_rounded : Icons.send_rounded,
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
}

class _Avatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;

  const _Avatar({required this.name, required this.size, this.imageUrl});

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
        gradient: LinearGradient(colors: gradient,
            begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: imageUrl != null
          ? ClipOval(child: Image.network(imageUrl!, fit: BoxFit.cover))
          : Center(
              child: Text(name[0].toUpperCase(),
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700,
                      fontSize: (size * 0.38).sp, fontFamily: 'Roboto')),
            ),
    );
  }
}