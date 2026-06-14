import 'package:equatable/equatable.dart';
import 'package:sekka/Features/Profile/Profile/Data/Model/saved_post_model.dart';

enum SavedPostsStatus {
  initial,
  loading,
  success,
  error,
}

class SavedPostsState extends Equatable {
  final SavedPostsStatus status;
  final List<SavedPostModel> savedPosts;
  final String? errorMessage;

  const SavedPostsState({
    this.status = SavedPostsStatus.initial,
    this.savedPosts = const [],
    this.errorMessage,
  });

  SavedPostsState copyWith({
    SavedPostsStatus? status,
    List<SavedPostModel>? savedPosts,
    String? errorMessage,
  }) {
    return SavedPostsState(
      status: status ?? this.status,
      savedPosts: savedPosts ?? this.savedPosts,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, savedPosts, errorMessage];
}
