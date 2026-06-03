import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sekka/Core/Database/local_data_source.dart';
import 'package:sekka/Features/Auth/Data/DataSource/supabase_data_source.dart';
import 'package:sekka/Features/Auth/Data/Model/signup_request.dart';
import 'package:sekka/Features/Auth/Data/Model/user_model.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';

import '../DataSource/firebase_datasource.dart';
import '../Model/signInRequest.dart';

class AuthRepo {

  final FirebaseDatasource firebaseDataSource;
  final SupabaseDataSource supabaseDataSource;
  final LocalUserDataSource localUserDataSource;

  const AuthRepo({
    required this.localUserDataSource,
    required this.supabaseDataSource,
    required this.firebaseDataSource,
  });


  Future<void> signInWithEmail(SignInRequest request) async {

    final isVerified = firebaseDataSource.isAccountVerified();

    if (isVerified) {
      await firebaseDataSource.signInWithEmail(request);
    } else {
      await firebaseDataSource.sendEmailVerification();
    }
  }

Future<void> loginWithGoogle() async {
  
  
  UserModel? existingUser;
  
  try {
    existingUser = await supabaseDataSource.getUser();
  } catch (_) {}

  final userModel = (existingUser ?? UserModel()).copyWith(
    id: FirebaseAuth.instance.currentUser!.uid,
    email: FirebaseAuth.instance.currentUser?.email ?? existingUser?.email,
  );

  await supabaseDataSource.upsertUser(userModel);
  await localUserDataSource.upsertUser(userModel);
}

  Future<void> signup(SignUpRequest request) async {
    await firebaseDataSource.signUp(request);
    await firebaseDataSource.sendEmailVerification();
  }

  Future<void> resendEmailVerification() async {
    await firebaseDataSource.sendEmailVerification();
  }

  // ---------------- VERIFY ----------------


Future<bool> isVerified({String? pendingName}) async {
  await firebaseDataSource.reloadUser();
  final user = firebaseDataSource.user;
  final isVerified = firebaseDataSource.isAccountVerified();

  if (user != null && isVerified) {
    UserModel? existingUser;
    try {
      existingUser = await supabaseDataSource.getUser();
    } catch (_) {}

    final userModel = UserModel(
      id: user.uid,
      email: user.email,
      name: existingUser?.name ?? pendingName,
      isGetStarted: existingUser?.isGetStarted ?? false,
    );

    await supabaseDataSource.upsertUser(userModel);
    await localUserDataSource.upsertUser(userModel);
  }

  return isVerified;
}


  // ---------------- IMAGE ----------------

  Future<String> uploadImage(XFile file) async {
    final user = firebaseDataSource.user;

    if (user == null) {
      throw Exception("User not logged in");
    }

    return await supabaseDataSource.uploadImage(file, user.uid);
  }

  // ---------------- UPDATE USER (CORE FIX 🔥) ----------------

  Future<void> updateUser(UpdateUserRequest request) async {
    try{
    final user = firebaseDataSource.user;

    if (user == null) throw Exception("User not logged in");
    await supabaseDataSource.updateUser(request);


    final cached = await localUserDataSource.getUser(user.uid);

    if (cached == null) return;

    final updatedUser = cached.copyWith(
      name: request.name ?? cached.name,
      phone: request.phone ?? cached.phone,
      image: request.image ?? cached.image,
      favTrasnportation:
          request.favTrasnportation ?? cached.favTrasnportation,
      isGetStarted: request.isGetStarted ?? cached.isGetStarted,
    );

    await localUserDataSource.upsertUser(updatedUser);
    }catch(e,stackTrace){
      debugPrint('AuthRepo updateUser error: $e');
      debugPrint('StackTrace: $stackTrace');
    }
  }


  Future<void> sendOtp(String otp, String phone) async {
    final data = await firebaseDataSource.submitOtp(otp);
    final user = data.user;

    if (user != null) {

      final userModel = UserModel(
        id: user.uid,
        phone: phone,
      );

      await supabaseDataSource.upsertUser(userModel);
      await localUserDataSource.upsertUser(userModel);
    }
  }


  Future<UserModel?> getProfile() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return await localUserDataSource.getUser(userId);
  }


  Future<void> resetPassword(String email) async {
    await firebaseDataSource.resetPassword(email);
  }

  Future<void> signInWithPhone(String phone) async {
    await firebaseDataSource.signInWithPhone(phone);
  }
}