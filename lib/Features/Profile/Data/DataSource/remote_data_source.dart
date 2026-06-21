import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sekka/Features/Auth/Data/Model/user_model.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteDataSource {
  final SupabaseClient supabaseClient;

  RemoteDataSource(this.supabaseClient);

  // ── Get User ─────────────────────────────────────────────────────────────
  Future<UserModel> getUser(String userId) async {
    try {
      final data = await supabaseClient
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return UserModel.fromJson(data);
    } catch (e, stackTrace) {
      print('⚠️ Failed to fetch user from remote: $e');
      print(stackTrace);
    }
    throw Exception('User not found');
  }

  // ── Update User ───────────────────────────────────────────────────────────
  Future<void> updateUser(UpdateUserRequest user) async {
    await supabaseClient
        .from('users')
        .update(user.toMap())
        .eq('id', FirebaseAuth.instance.currentUser!.uid)
        .select();
  }


  Future<String> updateProfileImage(File imageFile) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final storagePath = 'avatars/$userId.jpg';

    // Upload (upsert = overwrite if exists)
    await supabaseClient.storage
        .from('avatars') // ← اسم الـ bucket في Supabase
        .upload(
          storagePath,
          imageFile,
          fileOptions: const FileOptions(upsert: true),
        );

    // Get public URL
    final publicUrl = supabaseClient.storage
        .from('avatars')
        .getPublicUrl(storagePath);

    // Persist URL in users table
    await supabaseClient
        .from('users')
        .update({'image': publicUrl})
        .eq('id', userId);

    return publicUrl;
  }

  Future<void> deleteProfileImage() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final storagePath = 'avatars/$userId.jpg';

    // Delete from storage
    await supabaseClient.storage
        .from('avatars')
        .remove([storagePath]);

    await supabaseClient
        .from('users')
        .update({'image': null})
        .eq('id', userId);
  }
}