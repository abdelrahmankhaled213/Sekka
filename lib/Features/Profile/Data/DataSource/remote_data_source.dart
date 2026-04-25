import 'package:firebase_auth/firebase_auth.dart';
import 'package:sekka/Features/Auth/Data/Model/user_model.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteDataSource {
  
  final SupabaseClient supabaseClient;

  RemoteDataSource( this.supabaseClient);
  
Future<UserModel> getUser(String userId)async{

  final data = await supabaseClient.from('users').select().eq('id', userId).single();

  return UserModel.fromJson(data);
}


Future<void> updateUser(UpdateUserRequest user)async{

 await supabaseClient.from('users').update(user.toMap()) 
.eq('id',FirebaseAuth.instance.currentUser!.uid ).select();

}

}