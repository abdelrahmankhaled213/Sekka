import 'package:equatable/equatable.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/add_comment_response.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/comments.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';

enum LostFoundStatus 
{ 
 initial,
 addPostloading,
 addPostsuccess,
 addPostfailure ,
 getPostLoading,
 getPostSuccess,
 getPostFailure,
 updateCommentLoading,
 updateCommentSuccess,
 updateCommentFailure,
 deleteCommentLoading,
 deleteCommentSuccess,
 deleteCommentFailure,
 getCommmentLoading,
 getCommentSuccess,
 getCommentFailure,
 createCommentLoading,
 createCommentSuccess,
 createCommentFailure,
 updatePostLoading,
 updatePostSuccess,
 updatePostFailure,
 deletePostLoading,
 deletePostSuccess,
 deletePostFailure
}

class LostFoundState extends Equatable {
  
  final LostFoundStatus status;
  final String? errorMsg;
  final List<ItemModel>? items;
  final ItemModel? addedItemModel;
  final CommentModel? addCommentResponse;
  final List<CommentModel>?comments;
  final bool hasText;
  final bool isUpdatePressed;
  final int? editingCommentId;
  const LostFoundState({required this.status, this.addCommentResponse, this.isUpdatePressed=false
  ,  this.errorMsg , this.items, this.comments,this.addedItemModel,this.hasText=false,this.editingCommentId});


LostFoundState copyWith({
    LostFoundStatus? status,
    String? errorMsg,
    List<ItemModel>? items,
    List<CommentModel>? comments,
    ItemModel? addedItemModel,
    CommentModel? addCommentResponse,
    bool? hasText,
    bool?isUpdatePressed,
    int? editingCommentId
  }) {
    return LostFoundState(
    isUpdatePressed: isUpdatePressed ?? this.isUpdatePressed,
      items: items ?? this.items,
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
      comments: comments ?? this.comments,
      addedItemModel: addedItemModel ?? this.addedItemModel,
      addCommentResponse: addCommentResponse ?? this.addCommentResponse,
      hasText: hasText ?? this.hasText,
      editingCommentId: editingCommentId ?? this.editingCommentId
    
    );
  }

  @override
  List<Object?> get props => [status, errorMsg, items, comments, addedItemModel, addCommentResponse, hasText];
}