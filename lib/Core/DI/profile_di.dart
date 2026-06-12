import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Features/Profile/Data/DataSource/trip_history_local_data_source.dart';
import 'package:sekka/Features/Profile/Data/DataSource/trip_history_remote_data_source.dart';
import 'package:sekka/Features/Profile/Data/Repo/profile_repo.dart';
import 'package:sekka/Features/Profile/Data/DataSource/remote_data_source.dart';
import 'package:sekka/Features/Profile/Data/Repo/trip_history_repo.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/Logic/trip_history_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void>initProfileDI()async{
  
  getIt.registerLazySingleton<TripHistoryRemoteDataSource>(
    () => TripHistoryRemoteDataSource(Supabase.instance.client),
  );

  getIt.registerLazySingleton<TripHistoryRepository>(
    () => TripHistoryRepository(
      remoteDataSource: getIt<TripHistoryRemoteDataSource>(),
      localDataSource: getIt<TripHistoryLocalDataSource>(),
    ),
  );

  getIt.registerFactory<TripHistoryCubit>(
    () => TripHistoryCubit(getIt<TripHistoryRepository>()),
  );
  
    getIt.registerLazySingleton<TripHistoryLocalDataSource>(
    () => TripHistoryLocalDataSource(),
  );
  
   getIt.registerLazySingleton(() => RemoteDataSource(getIt()));
  
  getIt.registerLazySingleton(() => ProfileRepo(remoteDataSource: getIt()
  ,localUserDataSource: getIt()));
  getIt.registerFactory(() => ProfileCubit(getIt<ProfileRepo>()));

}
