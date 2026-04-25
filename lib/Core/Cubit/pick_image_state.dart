import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

enum PickImageEnum{
  uploadImageLoading,
  uploadImageLoaded,
  uploadImageError
}

 class PickImageState extends Equatable{

  final PickImageEnum? pickImageEnum;
  final String? imagePath;
  final XFile? file;
  final String? errorMsg;
  final String? imagePathFromSupa;

  PickImageState({
     this.pickImageEnum,
    this.file,
    this.imagePath,
    this.errorMsg,
    this.imagePathFromSupa
 });
  PickImageState copyWith({PickImageEnum?pickImageEnum,
  String? imagePath,
   XFile? file,
   String? errorMsg ,
    String? imagePathFromSupa
  }){
    return PickImageState(
      file: file??this.file,
      errorMsg: errorMsg??this.errorMsg,
      imagePath: imagePath??this.imagePath,
      imagePathFromSupa: imagePathFromSupa??this.imagePathFromSupa,
      pickImageEnum: pickImageEnum??this.pickImageEnum
    );
}

  @override
  // TODO: implement props
  List<Object?> get props => [file,imagePath,errorMsg,pickImageEnum,imagePathFromSupa];
 }

