import 'package:sekka/Features/Auth/Data/Repo/Auth_repo.dart';

class HandleVerificationUsecase {
  final AuthRepo _repo;
  HandleVerificationUsecase(this._repo);

  Future<bool> call({String? pendingName}) => 
      _repo.isVerified(pendingName: pendingName);
}