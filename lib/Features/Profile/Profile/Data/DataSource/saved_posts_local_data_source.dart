import 'package:hive/hive.dart';
import 'package:sekka/Features/Profile/Profile/Data/Model/saved_post_model.dart';

class SavedPostsLocalDataSource {
  static const String _boxName = 'savedPosts';

  Future<Box<SavedPostModel>> get _box async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<SavedPostModel>(_boxName);
    }
    return Hive.box<SavedPostModel>(_boxName);
  }

  Future<void> savePost(SavedPostModel savedPost) async {
    final box = await _box;
    await box.put(savedPost.postId, savedPost);
  }

  Future<void> unsavePost(String postId) async {
    final box = await _box;
    await box.delete(postId);
  }

  Future<List<SavedPostModel>> getSavedPosts() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<bool> isPostSaved(String postId) async {
    final box = await _box;
    return box.containsKey(postId);
  }

  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }
}
