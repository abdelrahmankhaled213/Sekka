import '../models/nearest_station_model.dart';

/// Cache بسيط في الـ memory — بيحتفظ بالنتيجة الأخيرة
class NearestStationLocalDataSource {
  List<NearestStationModel>? _cachedStations;
  DateTime?                  _cacheTime;

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
