import 'package:sekka/Features/Auth/Data/Model/signInRequest.dart';

import '../Repo/Auth_repo.dart';

class LoginUseCase {

  final AuthRepo repository;

  LoginUseCase(this.repository);

  Future<void> call(SignInRequest request) async {

  if (request.email != null && request.email!.isNotEmpty) {

  await repository.signInWithEmail(
 request
  );

  } 

  }

  }
