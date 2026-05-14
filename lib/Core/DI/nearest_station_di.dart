import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Features/NearestStation/Data/Model/DataSource/nearest_station_data_source.dart';
import 'package:sekka/Features/NearestStation/Data/Model/DataSource/capacity_prediction_service.dart';
import 'package:sekka/Features/NearestStation/Data/Model/Repo/nearest_station_repo.dart';
import 'package:sekka/Features/NearestStation/Logic/nearest_station_cubit.dart';

Future<void> initNearestStationDI() async {
  getIt.registerLazySingleton(
        () => NearestStationDataSource(supabaseClient: getIt()),
  );

  getIt.registerLazySingleton(
        () => NearestStationRepo(dataSource: getIt()),
  );

  getIt.registerLazySingleton(
        () => CapacityPredictionService(),
  );

  getIt.registerFactory(
        () => NearestStationCubit(getIt(), getIt()),
  );
}
