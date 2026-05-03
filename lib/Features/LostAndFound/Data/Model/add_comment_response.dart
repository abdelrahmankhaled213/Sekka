class AddCommentResponse {
  
  final String message;
  final String updatedAt;

  const AddCommentResponse({required this.updatedAt, required this.message,});

  factory AddCommentResponse.fromJson(Map<String, dynamic> json) {
    return AddCommentResponse(message: json['content'], updatedAt: json['created_at']);
  }
}

