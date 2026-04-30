import 'package:firebase_auth/firebase_auth.dart';

import 'package:sekka/Core/Database/local_data_source.dart';
import 'package:sekka/Features/Auth/Data/Model/user_model.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:sekka/Features/Profile/Data/DataSource/remote_data_source.dart';
class ProfileRepo {
  final RemoteDataSource remoteDataSource;
  final LocalUserDataSource localUserDataSource;

  const ProfileRepo({required this.remoteDataSource, required this.localUserDataSource});

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

    // 1. نحدث السيرفر الأول
    await remoteDataSource.updateUser(request);

    // 2. بدل ما نعتمد على الكاش القديم ونعمل copyWith
    // الأحسن نجيب اليوزر كامل من السيرفر تاني بعد التعديل عشان نضمن الدقة
    final updatedRemoteUser = await remoteDataSource.getUser(userId);

    // 3. نحدث الكاش باللي جه من السيرفر
    await localUserDataSource.upsertUser(updatedRemoteUser);
  }
}
