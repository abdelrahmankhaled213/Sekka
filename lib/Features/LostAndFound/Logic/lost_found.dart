import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Error/failure.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Data/Repo/lost_and_found_repo.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found_state.dart';

class LostAndFoundCubit extends Cubit<LostFoundState> {
  
  final LostAndFoundRepo lostAndFoundRepo;

  LostAndFoundCubit(this.lostAndFoundRepo) : super(LostFoundState(
    status: LostFoundStatus.initial
  ));

  Future<void> postLostAndFound(ItemModel item) async {
    emit(state.copyWith(status: LostFoundStatus.addPostloading));
    try {
    
    await lostAndFoundRepo.post(item);

      emit(state.copyWith( status: LostFoundStatus.addPostsuccess));

    } catch (e,stackTrace) {
      print(stackTrace.toString());
      print(e.toString());
      final Failure failure = ErrorHandler.handleError(e);
      emit(state.copyWith(status: LostFoundStatus.addPostfailure,errorMsg: failure.message));
    }
  }


}