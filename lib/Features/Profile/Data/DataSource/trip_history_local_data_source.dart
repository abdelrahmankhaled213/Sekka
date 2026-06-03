import 'package:hive/hive.dart';
import 'package:sekka/Features/Profile/Data/Model/trip_history_model.dart';

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

  Future<List<TripHistoryModel>> getTrips() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> deleteTrip(String tripId) async {
    final box = await _box;
    await box.delete(tripId);
  }

  Future<void> clearAll() async {
    final box = await _box;
    await box.clear();
  }

  Future<int> getTotalTrips() async {
    final trips = await getTrips();
    return trips.length;
  }

  Future<int> getCompletedTrips() async {
    final trips = await getTrips();
    return trips.where((trip) => trip.status == TripStatus.completed).length;
  }

  Future<int> getCancelledTrips() async {
    final trips = await getTrips();
    return trips.where((trip) => trip.status == TripStatus.cancelled).length;
  }
}
