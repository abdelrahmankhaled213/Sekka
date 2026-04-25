import 'package:sekka/Features/Auth/Data/Repo/Auth_repo.dart';

class GoogleSignInUseCase{

  final AuthRepo authRepo;
  GoogleSignInUseCase(this.authRepo);

  Future<void>call()async{

    await authRepo.loginWithGoogle();

  }
}