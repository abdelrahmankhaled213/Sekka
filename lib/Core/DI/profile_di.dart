import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Features/Profile/Profile/Data/DataSource/Repo/profile_repo.dart';
import 'package:sekka/Features/Profile/Profile/Data/DataSource/trip_history_local_data_source.dart';
import 'package:sekka/Features/Profile/Profile/Data/DataSource/trip_history_remote_data_source.dart';
import 'package:sekka/Features/Profile/Profile/Data/Repo/trip_history_repo.dart';
import 'package:sekka/Features/Profile/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/Profile/Logic/trip_history_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../Features/Profile/Profile/Data/DataSource/remote_data_source.dart';

Future<void> initProfileDI() async {
  getIt.registerLazySingleton(() => RemoteDataSource(getIt()));
  getIt.registerLazySingleton(
        () => ProfileRepo(
      remoteDataSource: getIt(),
      localUserDataSource: getIt(),
    ),
  );
  getIt.registerFactory(() => ProfileCubit(getIt<ProfileRepo>()));

  getIt.registerLazySingleton(() => TripHistoryLocalDataSource());
  getIt.registerLazySingleton(
        () => TripHistoryRemoteDataSource(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton(
        () => TripHistoryRepository(
      remoteDataSource: getIt(),
      localDataSource: getIt(),
    ),
  );
  getIt.registerFactory(() => TripHistoryCubit(getIt<TripHistoryRepository>()));
}
