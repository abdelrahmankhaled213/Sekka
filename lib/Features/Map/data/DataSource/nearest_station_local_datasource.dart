
import 'package:sekka/Features/NearestStation/Data/Model/nearest_station_model.dart';

class NearestStationLocalDataSource {
  
  List<NearestStationModel>? _cachedStations;
  DateTime? _cacheTime;

  static const Duration _cacheDuration = Duration(minutes: 5);

  bool get isCacheValid =>
      _cachedStations != null &&
      _cacheTime != null &&
      DateTime.now().difference(_cacheTime!) < _cacheDuration;

  List<NearestStationModel>? getCache() =>
      isCacheValid ? _cachedStations : null;

  void saveCache(List<NearestStationModel> stations) {
    _cachedStations = stations;
    _cacheTime      = DateTime.now();
  }

  void clearCache() {
    _cachedStations = null;
    _cacheTime      = null;
  }
}
