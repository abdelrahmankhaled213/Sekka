import 'package:bloc/bloc.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:sekka/Features/Auth/Data/UseCase/upsert_user_usecase.dart';
import 'package:sekka/Features/Auth/Logic/set_up_profile_state.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';

import '../../../Core/Error/error_handler.dart';
import '../Data/Model/user_model.dart';

class SetUpProfileCubit extends Cubit<SetupProfileState> {

  final UpsertUserUseCase upsertUserUseCase;

  SetUpProfileCubit({
    required this.upsertUserUseCase,
}) : super( const SetupProfileState());

  static const int _totalPages = 2;
  static const int _lastPageIndex = _totalPages - 1;

  final globalKey=GlobalKey<FormState>();

  final nameController = TextEditingController();

  final  ExpandablePageController controller=
  ExpandablePageController(itemCount: 2, initialPage: 0);

  final List<TransportType>chosenType=[];

  void setLoading(bool value) {
    emit(state.copyWith(isLoading: value));
  }

  int get currentPage => (controller.page ?? controller.initialPage.toDouble()).round();

  bool get canGoNext => currentPage < _lastPageIndex;

  bool get canGoBack => currentPage > 0;

  Future<void> goNextPage() async {

    if (!canGoNext) return;

    final nextPage = currentPage + 1;
    await controller.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
    emit(
      state.copyWith(
        step: nextPage + 1,
        progress: (nextPage + 1) / _totalPages,
      ),
    );
  }


  Future<void> goPreviousPage() async {

    if (!canGoBack) return;

    final previousPage = currentPage - 1;
    await controller.animateToPage(
      previousPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
    emit(
      state.copyWith(
        step: previousPage + 1,
        progress: (previousPage + 1) / _totalPages,
      ),
    );
  }

  Future<void>upsertUser(UpdateUserRequest model)async
  {

    emit(state.copyWith(
setUpProfileEnum: SetUpProfileEnum.upsertUserLoading

    ));


    try {

   await upsertUserUseCase(model);
   emit(state.copyWith(
     setUpProfileEnum: SetUpProfileEnum.upsertUserLoaded
   ));
    }catch(e,stackTrace){
print(e.toString());
      print(stackTrace);
      final failure=ErrorHandler.handleError(e);
      emit(state.copyWith(
        setUpProfileEnum: SetUpProfileEnum.upsertUserError,
        errorMsg: failure.message
      ));
    }

  }




@override
  Future<void> close() {
    controller.dispose();
    nameController.dispose();
      return super.close();
  }
}
