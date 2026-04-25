import 'package:sekka/Features/Auth/Data/Model/user_model.dart';

abstract class LocalUserDataSource {
  
  Future<void> upsertUser(UserModel user);
  Future<UserModel?> getUser(String userId);
  Future<UserModel?> getCurrentUser();
  Future<void> deleteUser(String userId);
  Future<void> clearAllUsers();
  Future<List<UserModel>> getAllUsers();

}