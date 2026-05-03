class UpdateCommentRequest {
  final int commentId;
  final String comment;

  UpdateCommentRequest({required this.commentId, required this.comment});
  Map<String, dynamic> toJson() => {'content': comment};
}