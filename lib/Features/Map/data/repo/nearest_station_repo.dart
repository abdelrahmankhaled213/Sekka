import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/Features/NearestStation/Data/Model/DataSource/nearest_station_data_source.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';

import '../DataSource/nearest_station_local_datasource.dart';

class MapRepo {

  final NearestStationDataSource remote;
  final NearestStationLocalDataSource  local;

  const MapRepo({required this.remote, required this.local});

  Future<List<NearestStationModel>> getNearestStations({
    required double lat,
    required double lng,
    TransportType? type,
    bool forceRefresh = false,
  }) async {
    
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