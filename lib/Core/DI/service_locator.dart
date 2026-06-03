import 'package:get_it/get_it.dart';
import 'package:sekka/Core/DI/auth_di.dart';
import 'package:sekka/Core/DI/core_di.dart';
import 'package:sekka/Core/DI/init_dio.dart';
import 'package:sekka/Core/DI/map_di.dart';
import 'package:sekka/Core/DI/nearest_station_di.dart';
import 'package:sekka/Core/DI/notification_di.dart';
import 'package:sekka/Core/DI/profile_di.dart';
import 'package:sekka/Core/DI/routes_di.dart';
import 'package:sekka/Core/DI/secure_storage.dart';
import 'package:sekka/Core/DI/lost_found_di.dart';
import 'package:sekka/Core/DI/where_to_go_di.dart';
import 'package:sekka/Features/Map/Data/DataSource/nearest_station_local_datasource.dart';
import 'package:sekka/Features/Map/Data/Repo/nearest_station_repo.dart';
import 'package:sekka/Features/Map/data/Logic/cubit/map_cubit.dart';

final getIt = GetIt.instance;

Future<void> init() async {

  await initCore();
  initAuthDI();
  initRoutesDI();
  initProfileDI();
  initDio();
  initSecureStorage();
  initNotificationDI();
  initLostAndFound();
  await initNearestStationDI();

   getIt.registerLazySingleton(() => NearestStationLocalDataSource(
  ));
  
  getIt.registerLazySingleton(() => MapRepo(local: getIt(), remote: getIt()));

  getIt.registerFactory<MapCubit>(() => MapCubit(repo: getIt<MapRepo>()));

 setupWhereToGoDI();

}

