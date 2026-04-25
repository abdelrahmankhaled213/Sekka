
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:sekka/Features/Auth/Data/Repo/Auth_repo.dart';


class UpsertUserUseCase{

  final AuthRepo authRepo;
  UpsertUserUseCase(this.authRepo);

  Future<void>call(UpdateUserRequest userModel)async{

    await authRepo.updateUser(userModel);

  }
}