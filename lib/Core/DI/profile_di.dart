import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Features/Profile/Data/DataSource/Repo/profile_repo.dart';
import 'package:sekka/Features/Profile/Data/DataSource/remote_data_source.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';

Future<void>initProfileDI()async{
  
  getIt.registerLazySingleton(() => RemoteDataSource(getIt()));
  getIt.registerLazySingleton(() => ProfileRepo(remoteDataSource: getIt()
  ,localUserDataSource: getIt()));
  getIt.registerFactory(() => ProfileCubit(getIt<ProfileRepo>()));

}