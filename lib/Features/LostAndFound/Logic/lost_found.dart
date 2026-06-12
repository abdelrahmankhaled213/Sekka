import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Error/failure.dart';
import 'package:sekka/Core/Helper/notification_helper.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/add_comment_request.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/update_comment_request.dart';
import 'package:sekka/Features/LostAndFound/Data/Repo/lost_and_found_repo.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found_state.dart';
import 'package:sekka/Features/LostAndFound/View/item_detail_and_chat_screen.dart';

class LostAndFoundCubit extends Cubit<LostFoundState> {
  final LostAndFoundRepo lostAndFoundRepo;

  LostAndFoundCubit(this.lostAndFoundRepo)
      : super(const LostFoundState(status: LostFoundStatus.initial));

  final controller = TextEditingController();

  // ── error helper — fix: كانت دايماً بتبعت addPostfailure ──────────────────

  void _mapError(Object e, StackTrace st, LostFoundStatus status) {
    debugPrint('LostAndFoundCubit error: $e\n$st');
    final Failure failure = ErrorHandler.handleError(e);
    emit(state.copyWith(status: status, errorMsg: failure.message)); // ← fix
  }

  // ── Notification navigation ────────────────────────────────────────────────
  // استدعيه في main() بعد NotificationHelper.init()
  // لما اليوزر يضغط على notification وهو برا الـ app — يروح للـ post المناسب

  static void handleNotificationNavigation({
    required Map<String, dynamic> data,
    required LostAndFoundRepo repo,
  }) {
    final postId = data['postId'] as String?;
    if (postId == null) return;

    // بنعمل navigate من غير context عشان ممكن يتكلم قبل الـ widget tree
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => LostAndFoundCubit(repo),
          child: ItemDetailAndChatScreen(
            // بنبعت item بـ id بس — الـ screen بتجيب الـ comments تلقائي
            item: ItemModel(
              id: int.tryParse(postId),
              category: data['category'] ?? 'lost',
              createdAt: data['createdAt'] ?? '',
              description: data['description'] ?? '',
              stationName: data['stationName'] ?? '',
              title: data['title'] ?? '',
              type: data['type'] == 'found' ? ItemType.found : ItemType.lost,
              userId: data['userId'] ?? '',
              userName: data['userName'],
              userImage: data['userImage'],
              commentCount: data['commentCount'],
              imageUrl: data['imageUrl'],
              isSaved: data['isSaved'] ?? false,
              
            ),
          ),
        ),
      ),
    );
  }

  // ── Posts ──────────────────────────────────────────────────────────────────

  Future<void> postLostAndFound(ItemModel item) async {
    emit(state.copyWith(status: LostFoundStatus.addPostloading));
    try {
      final added = await lostAndFoundRepo.post(item);
      emit(state.copyWith(
          status: LostFoundStatus.addPostsuccess, addedItemModel: added));
    } catch (e, st) {
      _mapError(e, st, LostFoundStatus.addPostfailure);
    }
  }

  Future<void> getPosts() async {
    emit(state.copyWith(status: LostFoundStatus.getPostLoading));
    try {
      final posts = await lostAndFoundRepo.getPosts();
      emit(state.copyWith(
          status: LostFoundStatus.getPostSuccess, items: posts));
    } catch (e, st) {
      _mapError(e, st, LostFoundStatus.getPostFailure);
    }
  }

  Future<void> deletePost(int postId) async {
    emit(state.copyWith(status: LostFoundStatus.deletePostLoading));
    try {
      await lostAndFoundRepo.deletePost(postId);
      emit(state.copyWith(status: LostFoundStatus.deletePostSuccess));
    } catch (e, st) {
      _mapError(e, st, LostFoundStatus.deletePostFailure);
    }
  }

  Future<void> updatePost(ItemModel item) async {
    emit(state.copyWith(status: LostFoundStatus.updatePostLoading));
    try {
      await lostAndFoundRepo.updatePost(item);
      emit(state.copyWith(status: LostFoundStatus.updatePostSuccess));
    } catch (e, st) {
      _mapError(e, st, LostFoundStatus.updatePostFailure);
    }
  }

  // ── Text field state ───────────────────────────────────────────────────────

  void closeTextField() {
    controller.clear();
    emit(state.copyWith(
      hasText:          false,
      editingCommentId: null,
      isUpdatePressed:  false,
    ));
  }

  void openTextField({required int commentId, required String commentText}) {
    controller.text = commentText;
    emit(state.copyWith(
      hasText:          true,
      isUpdatePressed:  true,
      editingCommentId: commentId,
    ));
  }

  void checkingTextFiledIsNotEmpty(bool isNotEmpty) =>
      emit(state.copyWith(hasText: isNotEmpty));

  // ── Comments ───────────────────────────────────────────────────────────────

  Future<void> getComments(int postId) async {
    emit(state.copyWith(status: LostFoundStatus.getCommmentLoading));
    try {
      final data = await lostAndFoundRepo.getComments(postId);
      emit(state.copyWith(
          status: LostFoundStatus.getCommentSuccess, comments: data));
    } catch (e, st) {
      _mapError(e, st, LostFoundStatus.getCommentFailure);
    }
  }

  Future<void> addComment(AddCommentRequest request) async {
    emit(state.copyWith(status: LostFoundStatus.createCommentLoading));
    try {
      final added = await lostAndFoundRepo.addComment(request);
      emit(state.copyWith(
        status:             LostFoundStatus.createCommentSuccess,
        addCommentResponse: added,
      ));
      await getComments(request.postId);
    } catch (e, st) {
      _mapError(e, st, LostFoundStatus.createCommentFailure);
    }
  }

  Future<void> deleteComment(int commentId) async {
    emit(state.copyWith(status: LostFoundStatus.deleteCommentLoading));
    try {
      await lostAndFoundRepo.deleteComment(commentId);

      final postId = state.comments
          ?.firstWhere((c) => c.id == commentId)
          .postId;

      emit(state.copyWith(status: LostFoundStatus.deleteCommentSuccess));

      if (postId != null) await getComments(int.parse(postId));
    } catch (e, st) {
      _mapError(e, st, LostFoundStatus.deleteCommentFailure);
    }
  }

  Future<void> updateComment(String newContent) async {
    if (state.editingCommentId == null) return;

    emit(state.copyWith(status: LostFoundStatus.updateCommentLoading));
    try {
      final original = state.comments!
          .firstWhere((c) => c.id == state.editingCommentId);

      await lostAndFoundRepo.updateComment(UpdateCommentRequest(
        commentId: original.id!,
        comment:   newContent,
      ));

      emit(state.copyWith(status: LostFoundStatus.updateCommentSuccess));
      closeTextField();

      // refresh
      await getComments(int.parse(original.postId));
    } catch (e, st) {
      _mapError(e, st, LostFoundStatus.updateCommentFailure);
    }
  }

  // ── Save posts ─────────────────────────────────────────────────────────────

  Future<void> toggleSavePost(String postId) async {
    emit(state.copyWith(status: LostFoundStatus.toggleSavePostLoading));
    try {
      await lostAndFoundRepo.toggleSavePost(postId);

      final updatedItems = state.items?.map((item) {
        if (item.id.toString() == postId) {
          return item.copyWith(isSaved: !item.isSaved);
        }
        return item;
      }).toList();

      emit(state.copyWith(
        status: LostFoundStatus.toggleSavePostSuccess,
        items:  updatedItems,
      ));
    } catch (e, st) {
      _mapError(e, st, LostFoundStatus.toggleSavePostFailure);
    }
  }

  Future<void> getSavedPosts() async {
    emit(state.copyWith(status: LostFoundStatus.getSavedPostsLoading));
    try {
      final saved = await lostAndFoundRepo.getSavedPosts();
      emit(state.copyWith(
        status:     LostFoundStatus.getSavedPostsSuccess,
        savedPosts: saved,
      ));
    } catch (e, st) {
      _mapError(e, st, LostFoundStatus.getSavedPostsFailure);
    }
  }

  // ── Image upload ───────────────────────────────────────────────────────────

  Future<String> uploadPostImage(File file, String userId) =>
      lostAndFoundRepo.uploadPostImage(file, userId);

  @override
  Future<void> close() {
    controller.dispose();
    return super.close();
  }
}