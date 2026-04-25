import 'package:sekka/Features/Auth/Data/Model/user_model.dart';
import 'package:sekka/Features/Auth/Data/Repo/Auth_repo.dart';

class GetProfileUsecase {
  
  final AuthRepo authRepo;

  GetProfileUsecase(this.authRepo);
  Future<UserModel?>call()async{

    return await authRepo.getProfile();
  }

}