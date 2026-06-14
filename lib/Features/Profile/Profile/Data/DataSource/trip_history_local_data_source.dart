import 'package:hive/hive.dart';
import 'package:sekka/Features/Profile/Profile/Data/Model/trip_history_model.dart';

class TripHistoryLocalDataSource {
  static const String _boxName = 'tripHistory';

  Future<Box<TripHistoryModel>> get _box async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<TripHistoryModel>(_boxName);
    }
    return Hive.box<TripHistoryModel>(_boxName);
  }

  Future<void> saveTrip(TripHistoryModel trip) async {
    final box = await _box;
    await box.put(trip.id, trip);
  }

  Future<void> saveAllTrips(List<TripHistoryModel> trips) async {
    final box = await _box;
    final map = {for (final t in trips) t.id: t};
    await box.putAll(map);
  }

  Future<List<TripHistoryModel>> getTrips() async {
    final box = await _box;
    final list = box.values.toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return list;
  }

  Future<void> deleteTrip(String tripId) async {
    final box = await _box;
    await box.delete(tripId);
  }

  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }

  Future<int> getTotalTrips() async => (await getTrips()).length;

}
