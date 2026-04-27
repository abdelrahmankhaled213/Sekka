import 'package:firebase_auth/firebase_auth.dart';

import 'package:sekka/Core/Database/local_data_source.dart';
import 'package:sekka/Features/Auth/Data/Model/user_model.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:sekka/Features/Profile/Data/DataSource/remote_data_source.dart';

class ProfileRepo{

final RemoteDataSource remoteDataSource;
final LocalUserDataSource localUserDataSource;

const ProfileRepo({required this.remoteDataSource,required this.localUserDataSource});

  Future<UserModel> getUser(String userId) async {
    
    final cachedUser = await localUserDataSource.getUser(userId);
    if (cachedUser != null) return cachedUser;

    final remoteUser = await remoteDataSource.getUser(userId);
    await localUserDataSource.upsertUser(remoteUser);
    return remoteUser;
  }



Future<void> editUser(UpdateUserRequest request) async {

  final userId = FirebaseAuth.instance.currentUser!.uid;

  await remoteDataSource.updateUser(request);

  final cachedUser = await localUserDataSource.getUser(userId);

  if (cachedUser == null) return;

  final updatedUser = cachedUser.copyWith(
    name: request.name ?? cachedUser.name,
    phone: request.phone ?? cachedUser.phone,
    image: request.image ?? cachedUser.image,
    favTrasnportation:
        request.favTrasnportation ?? cachedUser.favTrasnportation,
    isGetStarted: request.isGetStarted ?? cachedUser.isGetStarted,
  );

  await localUserDataSource.upsertUser(updatedUser);

}


