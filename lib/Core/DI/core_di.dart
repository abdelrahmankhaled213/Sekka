import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sekka/Core/DI/service_locator.dart';

import 'package:sekka/Core/Database/cache_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initCore() async {

  final sharedPref = await SharedPreferences.getInstance();
  
  getIt.registerLazySingleton(() => sharedPref);
  getIt.registerLazySingleton(() => CacheHelper(getIt()));

  getIt.registerLazySingleton(() => Supabase.instance.client);
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => GoogleSignIn.instance);

}
