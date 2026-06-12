  import 'package:sekka/Core/Helper/date_time_helper.dart';

class CommentModel {

  final int? id;
  final String postId;
  final String content;
  final String? createdAt;
  final String userId;
  final String userName;
  final String? userImage;

  const CommentModel({ this.id,required this.postId,required this.content
  , this.createdAt,required this.userId,required this.userName,required this.userImage});


factory CommentModel.fromJson(Map<String, dynamic> json) {
  return CommentModel(
    id: json['id'],
    postId: json['post_id']?.toString() ?? '',
    content: json['content'] ?? '',
    createdAt: DateTimeHelper.formatTimestamp(json['created_at'] ?? ''), 
    userId: json['user_id'] ?? '',
    userName: json['users']?['name'] ?? 'Unknown',
    userImage: json['users']?['image'] ?? '',
  );
}

CommentModel copyWith({
  int? id,
  String? postId,
  String? content,
  String? createdAt,
  String? userId,
  String? userName,
  String? userImage,
}) {
  return CommentModel(
    id: id ?? this.id,
    postId: postId ?? this.postId,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
    userId: userId ?? this.userId,
    userName: userName ?? this.userName,
    userImage: userImage ?? this.userImage,
  );
}

Map<String, dynamic> toJson() => {
  'id': id,
  'post_id': postId,
  'content': content,
  'created_at': createdAt,
  'user_id': userId,
  'users': {'name': userName, 'image': userImage},
};
}