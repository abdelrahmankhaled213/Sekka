import 'package:sekka/Core/Cubit/pick_image_cubit.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Core/Database/hive_data_source.dart';
import 'package:sekka/Core/Database/local_data_source.dart';
import 'package:sekka/Features/Auth/Data/DataSource/firebase_datasource.dart';
import 'package:sekka/Features/Auth/Data/DataSource/supabase_data_source.dart';
import 'package:sekka/Features/Auth/Data/Repo/Auth_repo.dart';
import 'package:sekka/Features/Auth/Data/UseCase/get_profile_usecase.dart';
import 'package:sekka/Features/Auth/Data/UseCase/google_sign_in_usecase.dart';
import 'package:sekka/Features/Auth/Data/UseCase/handle_verfication_usecase.dart';
import 'package:sekka/Features/Auth/Data/UseCase/resend_email_verification.dart';
import 'package:sekka/Features/Auth/Data/UseCase/reset_password_usecase.dart';
import 'package:sekka/Features/Auth/Data/UseCase/signIn_usecase.dart';
import 'package:sekka/Features/Auth/Data/UseCase/signup_usecase.dart';
import 'package:sekka/Features/Auth/Data/UseCase/submit_otp.dart';
import 'package:sekka/Features/Auth/Data/UseCase/upload_image_usecase.dart';
import 'package:sekka/Features/Auth/Data/UseCase/upsert_user_usecase.dart';
import 'package:sekka/Features/Auth/Logic/auth_cubit.dart';
import 'package:sekka/Features/Auth/Logic/set_up_profile_cubit.dart';

void initAuthDI()  {

  /// DataSources
  getIt.registerLazySingleton(() => SupabaseDataSource(getIt()));
  getIt.registerLazySingleton(() => FirebaseDatasource(getIt(), getIt()));
  getIt.registerLazySingleton<LocalUserDataSource>(() => HiveDataSource(
  ));


  /// Repo
  getIt.registerLazySingleton(() => AuthRepo(
       localUserDataSource: getIt(),
        supabaseDataSource: getIt(),
        firebaseDataSource: getIt(),
      ));

  /// UseCases
  /// 
  getIt.registerLazySingleton(() => SignUpUseCase(getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => SubmitOtpUseCase(getIt()));
  getIt.registerLazySingleton(() => HandleVerificationUsecase(getIt()));
  getIt.registerLazySingleton(() => GoogleSignInUseCase(getIt()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => ResendEmailVerification(getIt()));
  getIt.registerLazySingleton(() => UploadImageUseCase(getIt()));
  getIt.registerLazySingleton(() => UpsertUserUseCase(getIt()));
    getIt.registerLazySingleton(() => GetProfileUsecase(getIt()));

  /// Cubits
  
  getIt.registerFactory(() => AuthCubit(
        getProfileUsecase: getIt(),
        resendEmailVerification: getIt(),
        resetPasswordUseCase: getIt(),
        signupUseCase: getIt(),
        loginUseCase: getIt(),
        submitOtpUseCase: getIt(),
        handleVerificationUsecase: getIt(),
        googleSignInUseCase: getIt(),
      ));

  getIt.registerFactory(() => SetUpProfileCubit(
        upsertUserUseCase: getIt(),
      ));


  getIt.registerFactory(() => PickImageCubit(getIt()));

}