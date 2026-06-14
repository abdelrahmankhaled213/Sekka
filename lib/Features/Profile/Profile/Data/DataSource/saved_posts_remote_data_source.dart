import 'package:firebase_auth/firebase_auth.dart';
import 'package:sekka/Core/API/dio_consumer.dart';
import 'package:sekka/Features/Profile/Profile/Data/Model/saved_post_model.dart';

class SavedPostsRemoteDataSource {
  final DioConsumer api;

  SavedPostsRemoteDataSource({required this.api});

  Future<void> savePost(String postId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await api.post('/saved_posts', data: {
      'user_id': userId,
      'post_id': postId,
      'saved_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> unsavePost(String postId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await api.delete('/saved_posts?user_id=$userId&post_id=$postId');
  }

  Future<List<SavedPostModel>> getSavedPosts() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final response = await api.get('/saved_posts?user_id=$userId');
    return (response as List)
        .map((json) => SavedPostModel.fromJson(json))
        .toList();
  }

  Future<bool> isPostSaved(String postId) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final response = await api.get('/saved_posts?user_id=$userId&post_id=$postId');
    return (response as List).isNotEmpty;
  }
}
