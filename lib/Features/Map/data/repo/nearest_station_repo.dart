import '../datasource/nearest_station_local_datasource.dart';
import '../datasource/nearest_station_remote_datasource.dart';
import '../models/nearest_station_model.dart';
import '../models/transport_type.dart';

class NearestStationRepo {
  final NearestStationRemoteDataSource remote;
  final NearestStationLocalDataSource  local;

  const NearestStationRepo({required this.remote, required this.local});

  Future<List<NearestStationModel>> getNearestStations({
    required double lat,
    required double lng,
    TransportType? type,
    bool forceRefresh = false,
  }) async {
    // لو مفيش force refresh وفي cache صالح — ارجع الـ cache
    if (!forceRefresh) {
      final cached = local.getCache();
      if (cached != null) return cached;
    }

    final stations = await remote.getNearestStops(
      lat:  lat,
      lng:  lng,
      type: type,
    );

    local.saveCache(stations);
    return stations;
  }
}
