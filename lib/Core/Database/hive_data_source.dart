import 'package:hive/hive.dart';
import 'package:sekka/Core/Database/local_data_source.dart';
import 'package:sekka/Features/Auth/Data/Model/user_model.dart';

class HiveDataSource implements LocalUserDataSource {

  static const String _userBoxName = 'sekka_users_box2';
 
   Future<Box<UserModel>> get _userBox async {
    return await Hive.openBox<UserModel>(_userBoxName);
  }

  @override
  Future<void> clearAllUsers() async{

   final box=await _userBox;
   await box.clear();
  }

  @override
  Future<void> deleteUser(String userId) async{
   final box=await _userBox;
   await box.delete(userId);
  }

  @override
  Future<List<UserModel>> getAllUsers() async{
 
    final box= await _userBox;
    return box.values.toList();
  
  }

  @override
  Future<UserModel?> getCurrentUser() async{
   final box=await _userBox;
 if(box.isNotEmpty){
  return box.values.first;
                       }
   return null;
  }


  @override
  Future<UserModel?> getUser(String userId) async{
  final box = await _userBox;

   final data= box.get(userId);
   return data;
  }

  @override
  Future<void> upsertUser(UserModel user) async{
   final box = await _userBox;
  await box.put(user.id, user);
}

  }

   


