import 'package:sekka/Core/Cubit/trip_tracking_cubit.dart';
import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Features/Routes/Data/Model/DataSource/routes_data_source.dart';
import 'package:sekka/Features/Routes/Data/Model/Repo/routes_repo.dart';
import 'package:sekka/Features/Routes/Data/Model/Repo/trip_repo.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';

 
void initRoutesDI()  {

  /// DataSource
  getIt.registerLazySingleton(
      () => RoutesDataSource(supabaseClient: getIt()));

  /// Repo
  getIt.registerLazySingleton(
      () => RoutesRepo(routesDataSource: getIt()));
getIt.registerLazySingleton(
      () => TripsRepo( getIt()));
  /// Cubit
  getIt.registerFactory(() => RoutesCubit(getIt(), getIt()));
  getIt.registerFactory(() => TripCubit(getIt(), getIt()));
}
