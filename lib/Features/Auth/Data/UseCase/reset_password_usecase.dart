import '../Repo/Auth_repo.dart';

class ResetPasswordUseCase{
  final AuthRepo authRepo;
  ResetPasswordUseCase(this.authRepo);
  Future<void>call(String email)async{
    await authRepo.resetPassword(email);
  }
}