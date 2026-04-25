
import '../Repo/Auth_repo.dart';

class SubmitOtpUseCase{
  final AuthRepo repo;
  SubmitOtpUseCase(this.repo);
  Future<void> call(String otp,String phone)async{
    await repo.sendOtp(otp,phone);
  }
}