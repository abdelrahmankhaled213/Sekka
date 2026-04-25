import 'package:image_picker/image_picker.dart';
import 'package:sekka/Features/Auth/Data/Repo/Auth_repo.dart';

class UploadImageUseCase{

  final AuthRepo authRepo;

  UploadImageUseCase(this.authRepo);

  Future<String>call(XFile file)async{

    return await authRepo.uploadImage(file);

  }
}