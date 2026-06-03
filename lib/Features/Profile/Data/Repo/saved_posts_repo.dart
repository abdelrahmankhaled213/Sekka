import 'package:sekka/Features/Profile/Data/DataSource/saved_posts_local_data_source.dart';
import 'package:sekka/Features/Profile/Data/DataSource/saved_posts_remote_data_source.dart';
import 'package:sekka/Features/Profile/Data/Model/saved_post_model.dart';

class SavedPostsRepository {
  final SavedPostsRemoteDataSource remoteDataSource;
  final SavedPostsLocalDataSource localDataSource;

  SavedPostsRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<void> savePost(String postId) async {
    await remoteDataSource.savePost(postId);
    final savedPost = SavedPostModel(
      postId: postId,
      savedAt: DateTime.now().toIso8601String(),
    );
    await localDataSource.savePost(savedPost);
  }

  Future<void> unsavePost(String postId) async {
    await remoteDataSource.unsavePost(postId);
    await localDataSource.unsavePost(postId);
  }

  Future<List<SavedPostModel>> getSavedPosts() async {
    try {
      final remotePosts = await remoteDataSource.getSavedPosts();
      for (final post in remotePosts) {
        await localDataSource.savePost(post);
      }
      return remotePosts;
    } catch (e) {
      return await localDataSource.getSavedPosts();
    }
  }

  Future<bool> isPostSaved(String postId) async {
    try {
      return await remoteDataSource.isPostSaved(postId);
    } catch (e) {
      return await localDataSource.isPostSaved(postId);
    }
  }
}
