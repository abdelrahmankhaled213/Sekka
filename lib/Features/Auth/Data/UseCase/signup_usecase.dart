import 'package:sekka/Features/Auth/Data/Model/signup_request.dart';
import 'package:sekka/Features/Auth/Data/Repo/Auth_repo.dart';

class SignUpUseCase{

  final AuthRepo repo;
  SignUpUseCase(this.repo);
  Future<void>call(SignUpRequest request)async{
    await repo.signup(request);
  }
}