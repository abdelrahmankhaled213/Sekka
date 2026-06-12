import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Features/Map/Data/DataSource/nearest_station_local_datasource.dart';
import 'package:sekka/Features/Map/Data/Repo/nearest_station_repo.dart';
import 'package:sekka/Features/Map/data/Logic/cubit/map_cubit.dart';

void initMap(){
  
    getIt.registerLazySingleton(() => NearestStationLocalDataSource(
  ));
  
  getIt.registerLazySingleton(() => MapRepo(local: getIt(), remote: getIt()));

  getIt.registerFactory<MapCubit>(() => MapCubit(repo: getIt<MapRepo>()));
  
 
}