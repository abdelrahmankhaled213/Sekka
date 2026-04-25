import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../Data/Model/user_model.dart';

enum SetUpProfileEnum{
  uploadImageLoading,
  uploadImageLoaded,
  uploadImageError,
  upsertUserLoading,
  upsertUserLoaded,
  upsertUserError,
}

class SetupProfileState extends Equatable {

  final SetUpProfileEnum? setUpProfileEnum;
  final int step;
  final double progress;
  final String? name;
  final String imagePath;
  final bool isLoading;
  final XFile? file;
  final String? errorMsg;
  final String? imagePathFromSupa;
  final UserModel? currentUserModel;

  const SetupProfileState({
    this.currentUserModel,
    this.imagePathFromSupa,
    this.errorMsg,
    this.file,
    this.setUpProfileEnum,
    this.step = 1,
    this.progress = 0.5,
    this.name,
    this.imagePath='',
    this.isLoading = false,
  });

  SetupProfileState copyWith({

    String? errorMsg,
    int? step,
    double? progress,
    String? name,
    String? imagePath,
    bool? isLoading,
    SetUpProfileEnum? setUpProfileEnum,
    XFile? file,
    String? imagePathFromSupa,

  }) {
    return SetupProfileState(

      imagePathFromSupa: imagePathFromSupa??this.imagePathFromSupa,
      errorMsg: errorMsg??this.errorMsg,
      file: file??this.file,
      setUpProfileEnum: setUpProfileEnum??this.setUpProfileEnum,
      step: step ?? this.step,
      progress: progress ?? this.progress,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [setUpProfileEnum,imagePathFromSupa,errorMsg];

}