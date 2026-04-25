import 'package:sekka/Features/Auth/Data/Repo/Auth_repo.dart';

class ResendEmailVerification{
  final AuthRepo authRepo;
  ResendEmailVerification(this.authRepo);
  Future<void>call()async{
    await authRepo.resendEmailVerification();
  }
}