import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:postgrest/postgrest.dart';
import 'package:sekka/Core/Error/error_handler.dart';
import 'package:sekka/Core/Helper/location_helper.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/Features/NearestStation/Data/Model/DataSource/capacity_prediction_service.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';
import 'package:sekka/Features/NearestStation/Data/Model/Repo/nearest_station_repo.dart';
import 'package:sekka/Features/NearestStation/Logic/nearest_station_state.dart';

class NearestStationCubit extends Cubit<NearestStationState> {
  final NearestStationRepo repo;
  final CapacityPredictionService predictionService;

  NearestStationCubit(this.repo, this.predictionService)
      : super(const NearestStationState());

  Future<List<NearestStationModel>> _withPredictions(
      List<NearestStationModel> stations) async {
    final predictions = await Future.wait(
      stations.map((s) => s.id != null
          ? predictionService.getPredictionForStation(s.id!)
          : Future.value(null)),
    );

    return List.generate(stations.length, (i) {
      final prediction = predictions[i];
      return prediction != null
          ? stations[i].copyWith(crowding: prediction.crowdingLevel)
          : stations[i];
    });
  }

  Future<void> loadNearestStations() async {
    emit(state.copyWith(status: NearestStationStatus.loading));

    try {
      final position = await LocationHelper.determinePosition();

      if (position == null) {
        emit(state.copyWith(
          status: NearestStationStatus.error,
          errorMessage:
          'Could not get your location.\nPlease enable location services.',
        ));
        return;
      }

      String locationName = 'Your Location';
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          locationName = p.subLocality?.isNotEmpty == true
              ? p.subLocality!
              : p.locality ?? 'Your Location';
        }
      } catch (_) {}

      final rawStations = await repo.getNearestStops(
        lat: position.latitude,
        lng: position.longitude,
        type: state.selectedFilter,
      );

      final stations = await _withPredictions(rawStations);

      if (isClosed) return;

      emit(state.copyWith(
        status: NearestStationStatus.loaded,
        stations: stations,
        locationName: locationName,
        userLat: position.latitude,
        userLng: position.longitude,
      ));
    } catch (e) {
      if (isClosed) return;

      final errorMessage = e is PostgrestException
          ? e.message
          : ErrorHandler.handleError(e).message;

      emit(state.copyWith(
        status: NearestStationStatus.error,
        errorMessage: errorMessage,
      ));
    }
  }

  Future<void> loadNearestStationsForSearchedLocation({
    required double lat,
    required double lng,
    required String overrideName,
  }) async {
    emit(state.copyWith(
      status: NearestStationStatus.loading,
      locationName: overrideName,
      clearFilter: true,
    ));

    try {
      final rawStations = await repo.getNearestStops(
        lat: lat,
        lng: lng,
        type: null,
      );

      final stations = await _withPredictions(rawStations);

      if (isClosed) return;

      emit(state.copyWith(
        status: NearestStationStatus.loaded,
        stations: stations,
        locationName: overrideName,
        userLat: lat,
        userLng: lng,
      ));
    } catch (e) {
      if (isClosed) return;

      final errorMessage = e is PostgrestException
          ? e.message
          : ErrorHandler.handleError(e).message;

      emit(state.copyWith(
        status: NearestStationStatus.error,
        errorMessage: errorMessage,
      ));
    }
  }

  Future<void> applyFilter(TransportType? type) async {
    
    if (state.userLat == null || state.userLng == null) return;

    final isSame = type == state.selectedFilter;
    final newType = isSame ? null : type;

    emit(state.copyWith(
      status: NearestStationStatus.loading,
      selectedFilter: newType,
      clearFilter: newType == null,
    ));

    try {
      final rawStations = await repo.getNearestStops(
        lat: state.userLat!,
        lng: state.userLng!,
        type: newType,
      );

      final stations = await _withPredictions(rawStations);

      if (isClosed) return;

      emit(state.copyWith(
        status: NearestStationStatus.loaded,
        stations: stations,
      ));
    } catch (e) {
      if (isClosed) return;

      final errorMessage = e is PostgrestException
          ? e.message
          : ErrorHandler.handleError(e).message;

      emit(state.copyWith(
        status: NearestStationStatus.error,
        errorMessage: errorMessage,
      ));
    }
  }
}
