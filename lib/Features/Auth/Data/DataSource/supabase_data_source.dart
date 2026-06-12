import 'package:image_picker/image_picker.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Model/user_model.dart';

class SupabaseDataSource {
  final SupabaseClient client;
  SupabaseDataSource(this.client);


  Future<void> updateUser(UpdateUserRequest request, String uid) async {
    final data = request.toMap();
    if (data.isEmpty) return;

    await client
        .from('users')
        .update(data)
        .eq('id', uid)
        .single();
  }


  Future<void> upsertUser(UserModel user) async {
    if (user.id == null || user.id!.isEmpty) {
      throw Exception('Cannot upsert user: id is null or empty');
    }
    await client.from('users').upsert(user.toJson(), onConflict: 'id');
  }

  Future<UserModel> getUser(String uid) async {
    final data = await client
        .from('users')
        .select()
        .eq('id', uid)
        .single();

    return UserModel.fromJson(data);
  }

   Future<String> uploadImage(XFile file, String userId) async {
    final bytes = await file.readAsBytes();
    final fileExt = file.path.split('.').last;
    final fileName = "$userId.$fileExt";
    final path = "users/$fileName";

    await client.storage.from("avatars").uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(upsert: true),
    );

    return client.storage.from("avatars").getPublicUrl(path);
  }
}