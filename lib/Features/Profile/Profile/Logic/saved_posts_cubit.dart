import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Features/Profile/Profile/Data/Repo/saved_posts_repo.dart';
import 'package:sekka/Features/Profile/Profile/Logic/saved_posts_state.dart';

class SavedPostsCubit extends Cubit<SavedPostsState> {
  final SavedPostsRepository repository;

  SavedPostsCubit(this.repository) : super(const SavedPostsState());

  Future<void> loadSavedPosts() async {
    emit(state.copyWith(status: SavedPostsStatus.loading));
    try {
      final posts = await repository.getSavedPosts();
      emit(state.copyWith(
        status: SavedPostsStatus.success,
        savedPosts: posts,
      ));
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        status: SavedPostsStatus.error,
        errorMessage: failure.message,
      ));
    }
  }

  Future<void> savePost(String postId) async {
    try {
      await repository.savePost(postId);
      await loadSavedPosts();
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        status: SavedPostsStatus.error,
        errorMessage: failure.message,
      ));
    }
  }

  Future<void> unsavePost(String postId) async {
    try {
      await repository.unsavePost(postId);
      await loadSavedPosts();
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      emit(state.copyWith(
        status: SavedPostsStatus.error,
        errorMessage: failure.message,
      ));
    }
  }

  Future<bool> isPostSaved(String postId) async {
    try {
      return await repository.isPostSaved(postId);
    } catch (e) {
      return false;
    }
  }
}
