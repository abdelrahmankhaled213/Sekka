import 'package:sekka/Features/Auth/Logic/transport_model.dart';
import 'package:sekka/Features/NearestStation/Data/Model/DataSource/nearest_station_data_source.dart';
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';

class NearestStationRepo {
  final NearestStationDataSource dataSource;

  NearestStationRepo({required this.dataSource});

  Future<List<NearestStationModel>> getNearestStops({
    required double lat,
    required double lng,
    TransportType? type,
  }) async {
    return await dataSource.getNearestStops(
      lat: lat,
      lng: lng,
      type: type,
    );
  }
}
