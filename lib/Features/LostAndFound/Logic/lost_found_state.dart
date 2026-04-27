import 'package:equatable/equatable.dart';

enum LostFoundStatus 
{ 
 initial,
 addPostloading,
 addPostsuccess,
 addPostfailure ,
}

class LostFoundState extends Equatable {
  
  final LostFoundStatus status;
  final String? errorMsg;
  const LostFoundState({required this.status,  this.errorMsg});


LostFoundState copyWith({
    LostFoundStatus? status,
    String? errorMsg,
  }) {
    return LostFoundState(
      status: status ?? this.status,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }

  @override
  List<Object?> get props => [status, errorMsg];
}