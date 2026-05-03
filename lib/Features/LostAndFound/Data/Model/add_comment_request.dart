class AddCommentRequest {
  final String commentText;
  final String userId;
  final int postId;
  AddCommentRequest({required this.commentText,required this.postId,required this.userId});

  Map<String, dynamic> toJson() => {
    'content': commentText,
    'user_id': userId,
    'post_id': postId,
  };

}