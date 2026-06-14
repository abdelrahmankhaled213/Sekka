import 'package:sekka/Core/DI/service_locator.dart';
import 'package:sekka/Features/NearestStation/Data/Model/DataSource/place_autocomplete_service.dart';
import 'package:sekka/Features/Profile/Profile/Data/Repo/trip_history_repo.dart';
import 'package:sekka/Features/WhereToGo/Data/Repo/where_to_go.dart';
import 'package:sekka/Features/WhereToGo/Logic/where_to_go_cubit.dart';

void setupWhereToGoDI() {
  getIt.registerLazySingleton(
        () => WhereToGoRepo(getIt()),
  );

  getIt.registerLazySingleton(
        () => PlaceAutocompleteService(),
  );

  /// Cubit — TripHistoryRepository is already registered by initProfileDI()
  getIt.registerFactory<WhereToGoCubit>(
        () => WhereToGoCubit(
      repo:            getIt(),
      places:          getIt(),
      tripHistoryRepo: getIt<TripHistoryRepository>(),
    ),
  );
}
