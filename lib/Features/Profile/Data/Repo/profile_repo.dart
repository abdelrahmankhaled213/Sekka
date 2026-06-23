import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:sekka/Core/Database/local_data_source.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Features/Auth/Data/Model/user_model.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:sekka/Features/Profile/Data/DataSource/remote_data_source.dart';

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

    await remoteDataSource.updateUser(request);


    final updatedRemoteUser = await remoteDataSource.getUser(userId);

    await localUserDataSource.upsertUser(updatedRemoteUser);
  }

  Future<void> updateFavoriteTransports(List<TransportType?> types) async {
    await remoteDataSource.updateFavoriteTransports(types);
  }

  Future<void> deleteProfileImage() async {
    await remoteDataSource.deleteProfileImage();
  }
  Future<String> uploadProfileImage(File imageFile) async {
    return await remoteDataSource.updateProfileImage(imageFile);
  }

  Future<void> logout() async {
 
  await localUserDataSource.deleteUser(
    FirebaseAuth.instance.currentUser!.uid,
  );

  await FirebaseAuth.instance.signOut();

}

}