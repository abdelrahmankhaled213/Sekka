import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:sekka/Core/Cubit/pick_image_state.dart';

import '../../Features/Auth/Data/UseCase/upload_image_usecase.dart';
import '../Error/error_handler.dart';


class PickImageCubit extends Cubit<PickImageState> {

  final UploadImageUseCase uploadImageUseCase;

  PickImageCubit(this.uploadImageUseCase) : super(PickImageState());

  void pickImage(XFile file) {

    emit(state.copyWith(imagePath: file.path,file: file));

  }

void removeImage(){
  emit(state.copyWith(imagePath: '',file: null));
}

  Future<void>uploadImage()async{

    emit(state.copyWith(
        pickImageEnum: PickImageEnum.uploadImageLoading
    ));

    try {
      final url= await uploadImageUseCase(
        state.file!,
      );
      emit(state.copyWith(
        pickImageEnum: PickImageEnum.uploadImageLoaded,
imagePathFromSupa:url
      ));
    }catch(e,stacktrace){
      print(stacktrace.toString());
      print(e.toString());
      final failure=ErrorHandler.handleError(e);
      emit(state.copyWith(
          errorMsg: failure.message,
   pickImageEnum: PickImageEnum.uploadImageError
      ));
    }


  }


}
