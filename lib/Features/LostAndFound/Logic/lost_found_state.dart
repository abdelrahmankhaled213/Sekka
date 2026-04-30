import 'package:equatable/equatable.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';

enum LostFoundStatus 
{ 
 initial,
 addPostloading,
 addPostsuccess,
 addPostfailure ,
 getPostLoading,
 getPostSuccess,
 getPostFailure
}

class LostFoundState extends Equatable {
  
  final LostFoundStatus status;
  final String? errorMsg;
  final List<ItemModel>? items;

  const LostFoundState({required this.status,  this.errorMsg , this.items});


LostFoundState copyWith({
    LostFoundStatus? status,
    String? errorMsg,
    List<ItemModel>? items,
  }) {
    return LostFoundState(
      items: items ?? this.items,
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }

  @override
  List<Object?> get props => [status, errorMsg, items];
}