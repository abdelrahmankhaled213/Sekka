import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Model/user_model.dart';

class SupabaseDataSource{

  final SupabaseClient client;
  SupabaseDataSource(this.client);

Future<void> updateUser( UpdateUserRequest request) async {
  
  final data = request.toMap();

  if (data.isEmpty) return;

  await client
      .from('users')
      .update(data)
      .eq('id', FirebaseAuth.instance.currentUser!.uid)
      .single();
}
  Future<void>upsertUser(UserModel user)async{
await client.from('users').upsert(user.toJson(),onConflict: 'id');
  }

Future<UserModel>getUser() async {

final data=await client.from('users').select().eq('id',FirebaseAuth.instance.currentUser!.uid).single();

return UserModel.fromJson(data);

}

  Future<String>uploadImage(XFile file,String userId)async{

    final bytes=await file.readAsBytes();
    final fileExt = file.path.split('.').last;
    final fileName = "$userId.$fileExt";
    final path="users/$fileName";

    await client.storage.from("avatars")
        .uploadBinary(path, bytes,fileOptions: FileOptions(
      upsert: true
    ));

final imageUrl= client.storage.from("avatars").getPublicUrl(path);

return imageUrl;


  }

}