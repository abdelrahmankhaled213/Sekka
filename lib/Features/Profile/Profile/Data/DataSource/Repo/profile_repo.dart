import 'package:firebase_auth/firebase_auth.dart';

import 'package:sekka/Core/Database/local_data_source.dart';
import 'package:sekka/Features/Auth/Data/Model/user_model.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:sekka/Features/Profile/Profile/Data/DataSource/remote_data_source.dart';

class ProfileRepo {
  final RemoteDataSource remoteDataSource;
  final LocalUserDataSource localUserDataSource;

  const ProfileRepo(
      {required this.remoteDataSource, required this.localUserDataSource});

  Future<UserModel> getUser(String userId) async {
    try {
      final remoteUser = await remoteDataSource.getUser(userId);
      await localUserDataSource.upsertUser(remoteUser);
      return remoteUser;
    } catch (e) {
      final cachedUser = await localUserDataSource.getUser(userId);
      if (cachedUser != null) return cachedUser;
      rethrow;
    }
  }

  Future<void> editUser(UpdateUserRequest request) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // 1. Update the server first
    await remoteDataSource.updateUser(request);

    // 2. Fetch the full updated user from server to guarantee accuracy
    final updatedRemoteUser = await remoteDataSource.getUser(userId);

    // 3. Update local cache with the fresh server data
    await localUserDataSource.upsertUser(updatedRemoteUser);
  }
}