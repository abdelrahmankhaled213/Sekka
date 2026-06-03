import 'package:hive/hive.dart';

part 'saved_post_model.g.dart';

@HiveType(typeId: 3)
class SavedPostModel {
  @HiveField(0)
  final String postId;

  @HiveField(1)
  final String savedAt;

  SavedPostModel({
    required this.postId,
    required this.savedAt,
  });

  factory SavedPostModel.fromJson(Map<String, dynamic> json) {
    return SavedPostModel(
      postId: json['post_id'] as String,
      savedAt: json['saved_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'post_id': postId,
      'saved_at': savedAt,
    };
  }

  SavedPostModel copyWith({
    String? postId,
    String? savedAt,
  }) {
    return SavedPostModel(
      postId: postId ?? this.postId,
      savedAt: savedAt ?? this.savedAt,
    );
  }



}
