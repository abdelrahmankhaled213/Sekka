import 'package:sekka/Features/Auth/Data/Repo/Auth_repo.dart';

class HandleVerificationUsecase{

final AuthRepo authRepo;
HandleVerificationUsecase(this.authRepo);
  Future<bool>call()async{
return await authRepo.isVerified();
  }
}